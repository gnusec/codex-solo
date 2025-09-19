# SOLO Mode — Design and Technical Guide

This document explains how the vendored Codex CLI implements SOLO mode: configuration, event flow, key code paths, and common pitfalls.

## Goals

- Keep making progress automatically (no manual interaction) until a success condition is met.
- Support two kinds of success checks:
  - Done token printed by the model (done_token).
  - Explicit proof via command/shell exit code (success_cmd / success_sh).
- Allow customizing the prompt that drives the next turn (continue_prompt), whether to exit on success (exit_on_success), and a periodic delay (interval_seconds).
- Allow overriding the SOLO config file path via env so multiple instances in the same working directory can each use a different config file.

## Configuration and Environment Variables

- Default config file: `<cwd>/.codex-solo.json`.
- Override path (takes priority): `CODEX_SOLO_CONFIG=/path/to/solo.json`
  - If relative, resolves against `<cwd>`.

JSON fields:
- `autostart` (bool): enable SOLO automatically; can also use `CODEX_SOLO_AUTOSTART=1`.
- `kickoff_prompt` (string): initial prompt to send when SOLO is enabled (optional).
- `continue_prompt` (string): text used to drive the next turn.
- `done_token` (string): the done marker (default `"[SOLO_DONE]"`). If set to `""`, SOLO will not steer the model to print any marker.
- `success_cmd` (array[string]): argv-style command; success on exit code 0.
- `success_sh` (string): shell snippet; success on exit code 0 (Linux/macOS: `bash -lc`; Windows: `cmd /C`).
- `exit_on_success` (bool): if true, exit the CLI process when success is reached; can also use `CODEX_SOLO_EXIT_ON_SUCCESS=1`.
- `interval_seconds` (number): delay between automatic continuations; can also use `CODEX_SOLO_INTERVAL_SECONDS=60`.

## Key Code (TUI)

File: `vendor/codex/codex-rs/tui/src/chatwidget.rs`

- State fields (`struct ChatWidget`):
  - `solo_active: bool`
  - `solo_done_token: String`
  - `solo_continue_prompt: String`
  - `solo_success_cmd: Option<Vec<String>>`
  - `solo_success_sh: Option<String>`
  - `solo_exit_on_success: bool`
  - `solo_interval_seconds: Option<u64>`
  - `last_agent_message: Option<String>`

- Config parsing:
  - `load_solo_config_file()`
    - Reads `CODEX_SOLO_CONFIG` or `<cwd>/.codex-solo.json` and deserializes into `SoloConfigFile`.

- Autostart:
  - `maybe_autostart_solo()`
    - Enables SOLO if `CODEX_SOLO_AUTOSTART` is truthy; otherwise checks `autostart` in the config file.

- Enabling SOLO:
  - `enable_solo_mode()`
    - Applies settings (done_token / continue_prompt / success_cmd / success_sh / exit_on_success / interval_seconds).
    - Env overrides for `exit_on_success` and `interval_seconds`.
    - Switches approvals/sandbox to low-friction mode: `AskForApproval::OnFailure` + `WorkspaceWrite`.
    - If `kickoff_prompt` is present, sends it immediately (or queues it if a task is running).

- End-of-turn hook:
  - `on_solo_after_task()`
    - Calls `solo_success_reached()`:
      1) If `success_cmd` is set, runs it as argv; exit 0 => success.
      2) Else if `success_sh` is set, runs it via shell; exit 0 => success.
      3) Else if `done_token` is non-empty and the last agent message contains it => success.
    - If success:
      - Disables SOLO; if `solo_exit_on_success` is true, sends `ExitRequest` to exit the app.
    - If not:
      - If `solo_interval_seconds` > 0, spawns an async delay and then submits the next `continue_prompt`.
      - Otherwise, enqueues the next `continue_prompt` immediately.

- Continue prompt text:
  - `build_solo_continue_message()`
    - If `solo_done_token` is non-empty, appends “please print the marker … when done”.
    - If `solo_done_token` is `""`, it does not append the marker hint (prevents steering the model to print any marker).

- External checks:
  - `run_check_argv()` / `run_check_shell()` to execute the command/snippet and read the exit code.

## Runtime Flow (TUI)

1. Session configured → `maybe_autostart_solo()` decides whether to enable SOLO.
2. User/system submits `UserInput` (from `kickoff_prompt` or the next `continue_prompt`).
3. Model streams output; `TaskComplete` ends the turn.
4. `on_solo_after_task()` either exits (success) or schedules the next turn (immediately or after `interval_seconds`).

## Examples and Scenarios

- Multi-instance monitoring (`samples/solo/multi/`)
  - Console A (Runner): uses `a/solo-a.json`, polls success via `success_sh: "test -f FINISH.txt"`, exits on success.
  - Console B (Judge): uses `b/solo-b.json`, evaluates every 60s and writes proof files when done. Or `b/solo-b-exit.json` to also exit after creating a self-proof `JUDGE_DONE.txt`.
  - They share the same project directory but use different SOLO configs via `CODEX_SOLO_CONFIG`, avoiding conflicts.

## Pitfalls and Guidance

- “Print done marker” steering:
  - Earlier versions appended a marker hint to `continue_prompt`. With `done_token == ""`, the hint is now suppressed to avoid the model choosing a default marker like `[SOLO_DONE]`.

- Config file path conflicts:
  - In multi-process setups, use `CODEX_SOLO_CONFIG` to point each process at its own config file; do not share `<cwd>/.codex-solo.json`.

- Shell portability:
  - `success_sh` runs via `bash -lc` on Linux/macOS, and `cmd /C` on Windows. Choose syntax accordingly.

- Working directory and relative paths:
  - `success_sh`/`success_cmd` resolve relative paths against `<cwd>`. Ensure processes use the same working directory to share proof files.

## Quick Index

- `tui/src/chatwidget.rs`
  - SOLO state fields in `struct ChatWidget`
  - `load_solo_config_file()`
  - `maybe_autostart_solo()` / `enable_solo_mode()`
  - `on_solo_after_task()` / `solo_success_reached()`
  - `build_solo_continue_message()`
  - `run_check_argv()` / `run_check_shell()`

(Use `rg -n "SOLO|solo_" vendor/codex/codex-rs` to quickly search related code.)

