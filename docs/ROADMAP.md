# ROADMAP

This roadmap outlines near-term hardening and longer-term capabilities for Codex SOLO usage in this repo. Timelines are indicative; community feedback and upstream changes may adjust priorities.

## v0.1.x — Hardening & Community
- Discussions enabled in GitHub repository for Q&A and proposals.
- Issue labels baseline in place; guide triage and contribution.
- Docs: SOLO quick start, multi-instance A/B samples, success checks.
- Release automation for Linux/macOS/Windows with checksums.

## v0.2.0 — SOLO Quality & Cross Builds
- SOLO ergonomics:
  - Max-turns / time-budget guards.
  - Optional backoff between iterations and jitter control.
  - Clear terminal status for success/failure and last proof.
- Success checks:
  - Built-in recipes library (e.g., file exists, grep match, JSONPath).
  - Better logging for `success_cmd`/`success_sh` runs.
- Cross builds:
  - aarch64-unknown-linux-musl polish.
  - Optional OpenSSL static configuration for cross (documented and toggleable in CI).

## v0.3.0 — Templates & Extensibility
- Template library for common SOLO workflows (test-driven, lint-fix, doc-sync).
- Headless mode starter for CI-like runs.
- Config watchers and hot-reload of SOLO config.
- Plugin points for custom success checkers and reporters.

## Community & Governance
- Good first issues and help wanted labels to onboard contributors.
- Discussions categories for Q&A, Ideas, and Show & Tell.
- Lightweight decision notes filed under `docs/` for notable changes.

## How to Propose Changes
- Open a Discussion under Ideas describing the user story and constraints.
- If agreed, file an Issue labeled `enhancement` and reference the Discussion.
- Small PRs welcome; keep drift from upstream minimal.

