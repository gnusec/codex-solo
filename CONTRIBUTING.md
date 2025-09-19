# Contributing

Thanks for your interest in Codex SOLO! We keep changes small and focused to stay close to upstream Codex, so your PRs are easier to land and maintain.

- Fork and clone, then run:
  - `cd vendor/codex/codex-rs && cargo test -p codex-tui`
  - Optional: `cargo build -p codex-cli --release`
- For SOLO changes, prefer small diffs in `tui/src/chatwidget.rs` + tests.
- Before sending a PR:
  - `cargo fmt` (auto in CI)
  - `cargo test -p codex-tui`
- Upstream sync
  - Export patches: `bash scripts/vendor-export-patches.sh`
  - Sync & reapply: `bash scripts/vendor-sync-codex.sh`

We use GitHub Actions for CI. Tagging a release triggers multi‑platform builds (Linux, macOS, Windows) and uploads artifacts.

Questions? Open a Discussion or an Issue. Be kind and constructive — we ship more when we collaborate well.

