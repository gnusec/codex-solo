Two consoles, one project directory

- Console A (runner): keeps running until a proof file appears.
  - Set `CODEX_SOLO_CONFIG` to `samples/solo/multi/a/solo-a.json`.
  - Working directory: the project you are building.

- Console B (judge): every minute, evaluates project status; when done, creates `FINISH.txt`.
  - Set `CODEX_SOLO_CONFIG` to `samples/solo/multi/b/solo-b.json`.
  - Working directory: the same project directory as Console A.

Notes
- Use `exit_on_success: true` in console A so it exits immediately when `FINISH.txt` exists.
- Disable the done-token check for console B by setting `done_token` to an empty string, so it does not stop early.
- You can also set env vars: `CODEX_SOLO_AUTOSTART=1`, `CODEX_SOLO_EXIT_ON_SUCCESS=1` (A only), and `RUST_LOG` for diagnostics.

Script launcher
- Run both consoles with one command (tmux if available, else background):
  - `./run-dual.sh --tmux`  # in this directory (project dir defaults to $PWD)
  - or `./run-dual.sh -C /path/to/project --tmux`
- Make B also exit when done:
  - `./run-dual.sh --tmux --b-exit`
- Override codex binary or flags:
  - `CODEX_BIN=/abs/path/to/codex EXTRA_CLI_FLAGS="--ask-for-approval never --sandbox danger-full-access --model gpt-5 --config model_reasoning_effort=high" ./run-dual.sh --tmux`

Optional: also exit Console B when it finalizes
- Approach 1 (separate proof for B):
  - Configure B with its own success check, e.g. `success_sh: "test -f JUDGE_DONE.txt"` and `exit_on_success: true`.
  - In B's evaluation step, when it decides the project is complete, create both files:
    - `FINISH.txt` (signals A to stop), and
    - `JUDGE_DONE.txt` (signals B to stop).
  - Sample config: see `samples/solo/multi/b/solo-b-exit.json`.
- Approach 2 (reuse FINISH.txt):
  - Set B's success check to `success_sh: "test -f FINISH.txt"` and `exit_on_success: true`.
  - Since B writes `FINISH.txt` when done, it will also observe success and exit after creation.

Quick start
- Console A:
  - `CODEX_SOLO_CONFIG=$PWD/samples/solo/multi/a/solo-a.json CODEX_SOLO_AUTOSTART=1 ./codex`
- Console B (stay running):
  - `CODEX_SOLO_CONFIG=$PWD/samples/solo/multi/b/solo-b.json CODEX_SOLO_AUTOSTART=1 ./codex`
- Console B (exit when done):
  - `CODEX_SOLO_CONFIG=$PWD/samples/solo/multi/b/solo-b-exit.json CODEX_SOLO_AUTOSTART=1 ./codex`
