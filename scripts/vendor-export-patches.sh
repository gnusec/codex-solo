#!/usr/bin/env bash
set -euo pipefail

# Export our SOLO modifications in vendor/codex as a clean patch series under patches/codex-solo/.
#
# Behavior:
# - Computes base = merge-base(HEAD, origin/main) in vendor/codex.
# - If working tree is dirty, makes a temporary commit to capture local changes,
#   generates patches with `git format-patch`, then resets to restore the state.
# - Overwrites patches/codex-solo/*.patch by default.
#
# Usage:
#   bash scripts/vendor-export-patches.sh
# Env:
#   PATCH_DIR   Override output directory (default: patches/codex-solo)

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
codex_dir="$root_dir/vendor/codex"
patch_dir="${PATCH_DIR:-$root_dir/patches/codex-solo}"

if [[ ! -d "$codex_dir/.git" ]]; then
  echo "vendor/codex is not a git repo; aborting." >&2
  exit 2
fi

mkdir -p "$patch_dir"
rm -f "$patch_dir"/*.patch || true

echo "==> Fetching upstream"
git -C "$codex_dir" fetch origin --tags --prune

base=$(git -C "$codex_dir" merge-base HEAD origin/main)
echo "Base: $base"

dirty=$(git -C "$codex_dir" status --porcelain=v1 -uno)
made_temp_commit=false
if [[ -n "$dirty" ]]; then
  echo "==> Working tree dirty; creating temporary commit for export"
  git -C "$codex_dir" add -A
  git -C "$codex_dir" commit -m "solo: local changes (export)" --no-verify
  made_temp_commit=true
fi

echo "==> Generating patch series"
git -C "$codex_dir" format-patch "$base"..HEAD -o "$patch_dir"

if $made_temp_commit; then
  echo "==> Restoring working tree (dropping temp commit)"
  git -C "$codex_dir" reset --mixed HEAD~1
fi

echo "==> Wrote patches to: $patch_dir"
ls -1 "$patch_dir"/*.patch 2>/dev/null || true

