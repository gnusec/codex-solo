Codex SOLO Mode (vendored) — Quick Start

Banner
  ____          _            _____  ____   ___   
 / ___|___   __| | ___  ___ | ____|/ ___| / _ \  
| |   / _ \ / _` |/ _ \/ __||  _|  \___ \| | | | 
| |__| (_) | (_| |  __/\__ \| |___  ___) | |_| | 
 \____\___/ \__,_|\___||___/|_____| |____/ \___/  SOLO keeps coding till it’s done.


This repository vendors Codex and exposes its built‑in SOLO mode in the interactive CLI (slash command `/solo`). SOLO mode keeps working automatically until a success condition is met, without further manual interaction.

Slogan
- SOLO: 1vALL. Grind until the proof says done.
- 中文：独闯天涯，凭证为王；不靠嘴，靠退出码。

Quick Overview
- Enable SOLO: type `/solo` in the TUI, or autostart via `CODEX_SOLO_AUTOSTART=1`.
- Config file: `.codex-solo.json` (override with `CODEX_SOLO_CONFIG=/path/to/solo.json`).
- Success options:
  - `done_token` (default `[SOLO_DONE]`); set to `""` to avoid steering the model to print any marker.
  - `success_cmd` (argv) or `success_sh` (shell) — success when exit code is 0 (e.g., `test -f FINISH.txt`).
- Auto-continue prompt: `continue_prompt`. Optional delay via `interval_seconds` or `CODEX_SOLO_INTERVAL_SECONDS`.
- Exit when done: `exit_on_success` or `CODEX_SOLO_EXIT_ON_SUCCESS=1`.
- Multi-instance in the same project: run two consoles with different `CODEX_SOLO_CONFIG` paths to avoid sharing one config file.

What’s included here:
- Vendored Codex source under `vendor/codex/`
- Usage examples for SOLO with `.codex-solo.json`
- A minimal Linux static build script for distribution

Getting Started
- Build Codex (interactive CLI + TUI):
  - `cd vendor/codex/codex-rs`
  - `cargo build -p codex-cli --release`
- Run interactive CLI (TUI):
  - `./target/release/codex`
- In the chat, type `/solo` to toggle SOLO mode (like `/status`).

How SOLO Works
- When enabled, after each task finishes SOLO will automatically send a short “continue” message to keep going.
- SOLO stops when a success condition is met. You can choose either:
  1) Done token in the model’s final message (default token `[SOLO_DONE]`).
  2) A shell/command check that returns exit code 0 only when success is achieved.
- Optional kickoff prompt can start the work immediately on entering SOLO.

Street‑smart TL;DR
- Talk is cheap — show me the zero exit code.
- 把重复活交给 SOLO；把“定义成功”的脑力交给你（`success_sh`/`success_cmd`）。
- 一把梭：`interval_seconds` 控节奏，`exit_on_success` 收官走人。

Configuration: `.codex-solo.json` (or override with `CODEX_SOLO_CONFIG`)
Place a file named `.codex-solo.json` in your working directory. Supported fields:
- `kickoff_prompt` (string): initial task/topic to start with (optional).
- `done_token` (string): text token the agent must print to signal success (default `[SOLO_DONE]`).
- `continue_prompt` (string): how SOLO asks to keep going each turn.
- `success_cmd` (array of strings): argv form, run directly; success when the command exits 0.
- `success_sh` (string): shell snippet run via `bash -lc` (Windows: `cmd /C`); success when exit 0.
- `exit_on_success` (boolean): when true, exit the CLI when success is reached.
 - `interval_seconds` (number): delay between automatic continue-turns. If set (e.g. 60), SOLO will wait this many seconds before sending the next `continue_prompt`.

Mode 1 — Topic only; agent self‑judges via a done token
Example `.codex-solo.json`:
{
  "kickoff_prompt": "实现一个CLI工具，读取CSV并输出JSON。最后请打印 [SOLO_DONE]",
  "done_token": "[SOLO_DONE]",
  "continue_prompt": "继续"
}
Usage:
- Start Codex, type `/solo` to enable. SOLO will continue until the agent prints `[SOLO_DONE]`.

Mode 2 — Topic + explicit success indicator (test or check)
Option A: use `success_cmd` (argv form)
{
  "kickoff_prompt": "补全实现并让测试通过",
  "success_cmd": ["pytest", "-q"],
  "continue_prompt": "继续（完善实现直到测试通过）"
}
Notes:
- Success when `pytest -q` exits with 0.

Option B: use `success_sh` (shell form) to assert a specific proof
{
  "kickoff_prompt": "实现并确保测试报告显示 42 passed",
  "success_sh": "pytest -q | tee /tmp/pytest.out >/dev/null && grep -q '42 passed' /tmp/pytest.out",
  "continue_prompt": "继续（直到报告精确显示 42 passed）",
  "exit_on_success": true
}
Notes:
- The shell snippet returns 0 only when the report exactly contains `42 passed`.
- You can replace with any scriptable proof, e.g. checking a file, exact output, or JSON value.

Interactive Usage Flow
- Put `.codex-solo.json` in your project root.
- Run `codex` (interactive).
- Type `/solo` to enable SOLO. Type `/solo` again to disable.
- SOLO temporarily sets a low‑friction context (ask‑for‑approval on‑failure + workspace‑write sandbox) so it can proceed without prompting unless something fails.

Autostart SOLO on Launch
- Env flag: set `CODEX_SOLO_AUTOSTART=1` before launching `codex`.
- Or add to `.codex-solo.json`:
  {
    "autostart": true,
    "kickoff_prompt": "...",
    "success_cmd": ["pytest", "-q"]
  }
Notes:
- Env flag takes priority over the file setting.
- Optional: to exit automatically once success is reached, set `CODEX_SOLO_EXIT_ON_SUCCESS=1` or add `"exit_on_success": true` to `.codex-solo.json`.
- Use `CODEX_SOLO_CONFIG=/path/to/solo.json` to point SOLO at a different config file (relative paths resolve against the working directory).
 - Optional: `CODEX_SOLO_INTERVAL_SECONDS=60` to set an interval between SOLO auto-continues.

Distributing to Others
- Linux static builds (best portability): use the provided script `scripts/build-static.sh`.
  - Produces statically‑linked binaries for x86_64 and aarch64 (musl) under `vendor/codex/codex-rs/target/<target>/release/codex`.
- macOS: build native (`cargo build -p codex-cli --release`) and distribute the `codex` binary. Static linking is not typical on macOS.
- Windows: build native (`cargo build -p codex-cli --release --target x86_64-pc-windows-msvc`).
- Package binaries per‑platform (e.g., zip/tar.gz) and publish as GitHub Releases or any artifact store.

Linux Static Build (musl)
- Prereqs: Rust toolchain, `rustup target add x86_64-unknown-linux-musl aarch64-unknown-linux-musl`.
- Run: `bash scripts/build-static.sh`
- Artifacts: see `vendor/codex/codex-rs/target/*-unknown-linux-musl/release/codex`.

Notes and Tips

Multi-instance (A/B) Template
- Console A — Runner (exits when FINISH.txt exists):
  - `CODEX_SOLO_CONFIG=$PWD/samples/solo/multi/a/solo-a.json CODEX_SOLO_AUTOSTART=1 ./codex`
- Console B — Judge (keeps running, writes FINISH.txt when done):
  - `CODEX_SOLO_CONFIG=$PWD/samples/solo/multi/b/solo-b.json CODEX_SOLO_AUTOSTART=1 ./codex`
- Console B — Judge (also exits when done, writes FINISH.txt and JUDGE_DONE.txt):
  - `CODEX_SOLO_CONFIG=$PWD/samples/solo/multi/b/solo-b-exit.json CODEX_SOLO_AUTOSTART=1 ./codex`
- Notes:
  - A detects success via `success_sh: "test -f FINISH.txt"` and can use `interval_seconds` for polling cadence.
  - B evaluates periodically (`interval_seconds`) and writes proof files; in the exit variant it also uses `success_sh: "test -f JUDGE_DONE.txt"` + `exit_on_success: true`.
  - Use `CODEX_SOLO_CONFIG` so each console uses its own SOLO config file; avoid sharing `<cwd>/.codex-solo.json`.
  - Set `done_token` to `""` to avoid steering the model to print a done marker.

A tiny joke (safe for work)
- EN: Your laptop works 9–9–6, SOLO works 0–0–7. Who’s the real MVP?
- 中文：兄弟，牛马要效率，SOLO 要证据。绿灯一亮，收工回家。

Documentation (Top 5 languages by speakers)
- English: `docs/README.en.md`
- 简体中文: `docs/README.zh-CN.md`
- Español: `docs/README.es.md`
- العربية: `docs/README.ar.md`
- हिन्दी: `docs/README.hi.md`
- Deep dive (EN): `docs/SOLO.en.md`
- 深入原理（中文）: `docs/SOLO.zh-CN.md`
- Guía avanzada (ES): `docs/SOLO.es.md`
- الدليل المتقدم (AR): `docs/SOLO.ar.md`
- उन्नत मार्गदर्शिका (HI): `docs/SOLO.hi.md`

Documentation
- English: `docs/README.en.md`
- 简体中文: `docs/README.zh-CN.md`
- Español: `docs/README.es.md`
- العربية: `docs/README.ar.md`
- हिन्दी: `docs/README.hi.md`
- Deep dive (EN): `docs/SOLO.en.md`
- 深入原理（中文）: `docs/SOLO.zh-CN.md`
- Guía avanzada (ES): `docs/SOLO.es.md`
- الدليل المتقدم (AR): `docs/SOLO.ar.md`
- उन्नत मार्गदर्शिका (HI): `docs/SOLO.hi.md`
- Keep your changes minimal: this repo relies on Codex’s built‑in SOLO mode via `/solo` and an autostart flag; upstream drift stays low.
- For complex success criteria, prefer `success_sh` and ensure your snippet returns exit 0 only when the condition is satisfied.
- If you want SOLO to start immediately on launch without typing `/solo`, add it to your workflow (e.g., start Codex and send `/solo` as the first action) or extend the TUI to read an env flag—left out here to minimize drift from upstream.
