#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
mkdir -p mailbox
[ -f mailbox/.gitkeep ] || :

CODEX_BIN="${CODEX_BIN:-}"
if [ -z "$CODEX_BIN" ]; then
  if [ -x ../../vendor/codex/codex-rs/target/release/codex ]; then
    CODEX_BIN=../../vendor/codex/codex-rs/target/release/codex
  elif command -v codex >/dev/null 2>&1; then
    CODEX_BIN=$(command -v codex)
  else
    echo "codex binary not found. Build vendor/codex/codex-rs or export CODEX_BIN" >&2
    exit 1
  fi
fi

run_a() {
  CODEX_SOLO_CONFIG=$PWD/solo-a.json CODEX_SOLO_AUTOSTART=1 "$CODEX_BIN"
}
run_b() {
  CODEX_SOLO_CONFIG=$PWD/solo-b.json CODEX_SOLO_AUTOSTART=1 "$CODEX_BIN"
}

if [ "${1:-}" = "--tmux" ] && command -v tmux >/dev/null 2>&1; then
  tmux new-session -d -s duet_a "bash -lc 'cd $PWD; run_a'"
  tmux split-window -h -t duet_a "bash -lc 'cd $PWD; run_b'"
  tmux attach -t duet_a
else
  echo "Starting A (Builder) in this terminal…" >&2
  echo "Open another terminal and run: CODEX_SOLO_CONFIG=$PWD/solo-b.json CODEX_SOLO_AUTOSTART=1 $CODEX_BIN" >&2
  run_a
fi

