Architecture & Design
======================

This document explains how this repo vendors Codex and layers a practical SOLO mode on top, plus how success checks and CI/headless use work.

Diagram
![Architecture](../assets/architecture.svg)

Goals
- Keep upstream drift minimal (vendor Codex; avoid intrusive changes)
- Automate progress with a loop, not with guesswork
- Define success by proof (exit 0, files/outputs/tests), not by wording

Components
- Codex TUI (vendor): interactive CLI used as the operator console
- SOLO Controller: auto-continue loop with `continue_prompt`, `interval_seconds`, `exit_on_success`
- Success Checker: `done_token` or scriptable checks via `success_cmd` / `success_sh` (exit 0)
- Config Loader: `.codex-solo.json` or `CODEX_SOLO_CONFIG`
- Multi-instance A/B: Runner (watches a proof) and Judge (produces proof)
- Headless/CI: pseudo‑TTY + autostart + scriptable success checks

Data Flow
1) User toggles SOLO in TUI (`/solo`) or autostarts via env/file
2) Controller sends short continue prompts; optional interval pacing
3) After each iteration, Success Checker runs: token match OR external command/shell returning 0
4) If success → optional exit; else continue

Design Notes
- Prefer `success_sh` for precise proofs (grep report, check JSON/file)
- `done_token` can be disabled by setting it to empty string
- A/B multi‑instance: use different `CODEX_SOLO_CONFIG` to decouple configs
- Headless: keep logs compact; short and precise checks

Extensibility
- New check recipes can be added (e.g., JSONPath match, HTTP checks)
- CI examples can download a released `codex` binary for self‑hosted jobs

