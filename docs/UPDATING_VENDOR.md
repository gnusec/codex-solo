Updating vendored Codex to upstream latest (while keeping SOLO)

This repo vendors OpenAI Codex under `vendor/codex/` (it is a nested git repo with `origin` set to upstream). Our SOLO changes are maintained as a patch series so we can re-apply them on top of new upstream revisions.

Quick path (scripted)
1) Export/refresh patch series（推荐脚本）：
   - `bash scripts/vendor-export-patches.sh`
   - 脚本会：fetch upstream → 计算 base（origin/main）→ 临时提交本地改动（若有）→ 生成 patch（git format-patch）→ 恢复本地改动。
2) Run the sync script from repo root:
   - `bash scripts/vendor-sync-codex.sh`
   - This will fetch upstream, reset vendor to `origin/main`, apply patches from `patches/codex-solo/`, run format/tests, and build the x86_64 musl binary.
3) Inspect results, fix conflicts if needed:
   - If `git am` failed, resolve conflicts in `vendor/codex`, then run `git am --continue`.
   - Re-run tests and build.
4) Commit changes from the outer repo root so the new vendor files are captured.

Notes
- Keep our SOLO deltas small and localized (e.g., `tui/src/chatwidget.rs`), which reduces rebase conflicts.
- If upstream picks up equivalent features, prefer switching to upstream behavior and pruning our patches to minimize drift.
- CI builds x86_64 musl binary on every PR; releases attach artifacts on tag push.
