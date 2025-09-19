#!/usr/bin/env bash
set -euo pipefail

# One‑shot launcher for two Codex SOLO consoles (A Runner + B Judge) in the same project directory.
#
# Usage:
#   ./run-dual.sh [-C <project_dir>] [--b-exit] [--tmux]
# Env:
#   CODEX_BIN           Path to codex binary. Search order if unset:
#                       ./codex-solo,
#                       vendor/codex/codex-rs/target/x86_64-unknown-linux-musl/release/codex,
#                       codex (from PATH)
#   EXTRA_CLI_FLAGS     Extra flags appended to both A/B (e.g. "--ask-for-approval never --sandbox danger-full-access --model gpt-5 --config model_reasoning_effort=high")
#   A_CONFIG            Override A's SOLO config (default: samples/solo/multi/a/solo-a.json)
#   B_CONFIG            Override B's SOLO config (default: samples/solo/multi/b/solo-b.json or b/solo-b-exit.json with --b-exit)
#
# Notes:
# - Both consoles run in the same project directory so relative checks (e.g., test -f FINISH.txt) match.
# - Use --b-exit to make B also exit after writing JUDGE_DONE.txt (b/solo-b-exit.json).
# - Use --tmux to launch panes inside a new tmux session; without tmux, both run in background and write logs.

here="$(cd -- "$(dirname -- "$0")" && pwd)"
root="$(cd -- "$here/../../.." && pwd)"
project_dir="$PWD"
use_b_exit=false
use_tmux=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -C)
      project_dir="$2"; shift 2 ;;
    --b-exit)
      use_b_exit=true; shift ;;
    --tmux)
      use_tmux=true; shift ;;
    -h|--help)
      grep -E '^#( |$)' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)
      echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

# Resolve configs
default_a_cfg="$root/samples/solo/multi/a/solo-a.json"
default_b_cfg="$root/samples/solo/multi/b/solo-b.json"
default_b_exit_cfg="$root/samples/solo/multi/b/solo-b-exit.json"
A_CONFIG="${A_CONFIG:-$default_a_cfg}"
if $use_b_exit; then
  B_CONFIG="${B_CONFIG:-$default_b_exit_cfg}"
else
  B_CONFIG="${B_CONFIG:-$default_b_cfg}"
fi

[[ -f "$A_CONFIG" ]] || { echo "Missing A config: $A_CONFIG" >&2; exit 1; }
[[ -f "$B_CONFIG" ]] || { echo "Missing B config: $B_CONFIG" >&2; exit 1; }

# Resolve codex binary
if [[ -n "${CODEX_BIN:-}" ]]; then
  bin="$CODEX_BIN"
elif [[ -x "$PWD/codex-solo" ]]; then
  bin="$PWD/codex-solo"
elif [[ -x "$root/vendor/codex/codex-rs/target/x86_64-unknown-linux-musl/release/codex" ]]; then
  bin="$root/vendor/codex/codex-rs/target/x86_64-unknown-linux-musl/release/codex"
else
  bin="$(command -v codex || true)"
fi
[[ -x "$bin" ]] || { echo "Could not resolve codex binary. Set CODEX_BIN or place ./codex-solo." >&2; exit 1; }

export CODEX_SOLO_AUTOSTART=1
common_flags=${EXTRA_CLI_FLAGS:-"--ask-for-approval never --sandbox danger-full-access"}

cmd_a=(bash -lc "cd \"$project_dir\" && CODEX_SOLO_CONFIG=\"$A_CONFIG\" CODEX_SOLO_AUTOSTART=1 \"$bin\" $common_flags")
cmd_b=(bash -lc "cd \"$project_dir\" && CODEX_SOLO_CONFIG=\"$B_CONFIG\" CODEX_SOLO_AUTOSTART=1 \"$bin\" $common_flags")

echo "Project dir : $project_dir"
echo "Binary      : $bin"
echo "A config    : $A_CONFIG"
echo "B config    : $B_CONFIG"
echo "Extra flags : $common_flags"

if $use_tmux; then
  if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux not found; falling back to background mode." >&2
  else
    sess="codex-solo-dual"
    tmux new-session -d -s "$sess" "${cmd_a[@]}"
    tmux split-window -v -t "$sess:0" "${cmd_b[@]}"
    tmux select-pane -t 0
    tmux setw remain-on-exit on
    echo "Attached to tmux session: $sess"
    exec tmux attach -t "$sess"
  fi
fi

# Background mode
logdir="$project_dir/.codex-solo-logs"
mkdir -p "$logdir"
ts() { date +"%Y-%m-%dT%H:%M:%S%z"; }

echo "[INFO] ($(ts)) starting background consoles; logs in $logdir" | tee -a "$logdir/runner.log" "$logdir/judge.log"
nohup "${cmd_a[@]}" >"$logdir/runner.log" 2>&1 & echo $! >"$logdir/runner.pid"
nohup "${cmd_b[@]}" >"$logdir/judge.log" 2>&1 & echo $! >"$logdir/judge.pid"
echo "Runner PID: $(cat "$logdir/runner.pid")"
echo "Judge  PID: $(cat "$logdir/judge.pid")"
echo "Tail logs: tail -F '$logdir/runner.log' '$logdir/judge.log'"

