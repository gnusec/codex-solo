#!/usr/bin/env bash
set -euo pipefail

# Sync vendored upstream codex to latest origin/main, then re-apply our SOLO patches.
# Requires: vendor/codex is a git repo with remote "origin" pointing to upstream.

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
codex_dir="$root_dir/vendor/codex"
patch_dir="$root_dir/patches/codex-solo"

if [[ ! -d "$codex_dir/.git" ]]; then
  echo "vendor/codex is not a git repo; aborting." >&2
  exit 2
fi

echo "==> Fetching upstream"
git -C "$codex_dir" fetch origin --tags --prune

echo "==> Stashing local changes (if any)"
git -C "$codex_dir" stash push -u -m "pre-sync-$(date +%s)" || true

echo "==> Reset to origin/main"
git -C "$codex_dir" checkout -B solo-ext origin/main

if [[ -d "$patch_dir" && -n $(ls -1 "$patch_dir"/*.patch 2>/dev/null || true) ]]; then
  echo "==> Applying SOLO patches"
  # Try mail-style patches first, fall back to raw unified diffs with git apply.
  if ! git -C "$codex_dir" am --3way "$patch_dir"/*.patch; then
    echo "git am failed; trying git apply --3way..."
    if ! git -C "$codex_dir" apply -p1 --3way "$patch_dir"/*.patch; then
      echo "Patch apply failed. Resolve in $codex_dir, then retry." >&2
      exit 1
    fi
  fi
else
  echo "No patches found in $patch_dir; skipping apply."
fi

echo "==> Running format + basic tests"
pushd "$codex_dir/codex-rs" >/dev/null
cargo fmt
cargo test -p codex-tui --no-fail-fast -- --nocapture
popd >/dev/null

echo "==> Building x86_64 musl binary"
pushd "$codex_dir/codex-rs" >/dev/null
rustup target add x86_64-unknown-linux-musl >/dev/null || true
cargo build -p codex-cli --release --target x86_64-unknown-linux-musl
echo "Built: $(realpath target/x86_64-unknown-linux-musl/release/codex)"
popd >/dev/null

echo "Done. Review and commit updated vendor files from the outer repo."
