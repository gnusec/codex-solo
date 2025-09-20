Languages:
[English](README.en.md) · [简体中文](README.zh-CN.md) · [Español](README.es.md) · [العربية](README.ar.md) · [हिन्दी](README.hi.md)

# Codex SOLO — Quick Guide

Quick links
- Releases: https://github.com/gnusec/codex-solo/releases
- Discussions: https://github.com/gnusec/codex-solo/discussions
- Contribute: ../CONTRIBUTING.md
- Roadmap: ROADMAP.md
- Good First Issues: https://github.com/gnusec/codex-solo/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22
- Help Wanted: https://github.com/gnusec/codex-solo/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22
- Show & Tell: https://github.com/gnusec/codex-solo/discussions/9

Contact
- Name: 耘峥
- Email: huangdeng@safe87.com
- WeChat: gnusec

Functional overview
- Automatically continues until success checks pass
- Scriptable checks: command/script exit 0, tests green, file/output match
- Supports autostart, interval between iterations, exit-on-success, multi-instance configs

Overview
- SOLO keeps working automatically until a success condition is met.
- Toggle in TUI with `/solo`, or autostart via env or file.

Configure with `.codex-solo.json` (or override via `CODEX_SOLO_CONFIG`)
- kickoff_prompt: initial topic/task (optional)
- done_token: text the agent prints to declare success (default `[SOLO_DONE]`)
   - If `done_token` is set to an empty string (`""`), SOLO will not append the “print done marker …” hint to `continue_prompt`; i.e., it will not steer the model to print any marker.
- continue_prompt: how SOLO asks to continue each turn
- success_cmd: argv form command; success if exit code is 0
- success_sh: shell string; success if exit code is 0
- exit_on_success: boolean; when true, exits the CLI when success is reached
 - interval_seconds: number; delay between auto-continue turns (e.g. 60)

Examples
1) Topic only; agent self‑judges with done token
```json
{
  "kickoff_prompt": "Build a CLI that reads CSV and prints JSON. Finally print [SOLO_DONE]",
  "done_token": "[SOLO_DONE]",
  "continue_prompt": "continue"
}
```

2) Topic + explicit check (command)
```json
{
  "kickoff_prompt": "Finish implementation and make tests pass",
  "success_cmd": ["pytest", "-q"],
  "continue_prompt": "continue (iterate until tests pass)"
}
```

3) Topic + explicit check (shell)
```json
{
  "kickoff_prompt": "Ensure the report shows 42 passed",
  "success_sh": "pytest -q | tee /tmp/pytest.out >/dev/null && grep -q '42 passed' /tmp/pytest.out",
  "continue_prompt": "continue (until report exactly shows 42 passed)",
  "exit_on_success": true
}
```

Autostart SOLO
- Env:
```bash
CODEX_SOLO_AUTOSTART=1 ./codex
```
- File: add `"autostart": true` to `.codex-solo.json` (env takes priority)
- Optional exit on success: set `CODEX_SOLO_EXIT_ON_SUCCESS=1` (or add `exit_on_success: true` to `.codex-solo.json`)
- Optional config override: `CODEX_SOLO_CONFIG=/path/to/solo.json` (relative to cwd if not absolute)
 - Optional interval: `CODEX_SOLO_INTERVAL_SECONDS=60` (or add `interval_seconds: 60` to `.codex-solo.json`)

Build (Linux static musl)
- Prereqs:
```bash
rustup target add x86_64-unknown-linux-musl aarch64-unknown-linux-musl
```
- Run:
```bash
bash scripts/build-static.sh
```

Deep Dive
- See: SOLO.en.md

Run
```bash
cd vendor/codex/codex-rs && cargo build -p codex-cli --release
./vendor/codex/codex-rs/target/release/codex  # then type /solo or use autostart
```
