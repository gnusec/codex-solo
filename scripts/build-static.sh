#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
pushd "$root_dir/vendor/codex/codex-rs" >/dev/null

echo "==> Ensuring Rust musl targets are installed"
rustup target add x86_64-unknown-linux-musl aarch64-unknown-linux-musl >/dev/null

echo "==> Building static codex (x86_64-unknown-linux-musl)"
cargo build -p codex-cli --bin codex --release --target x86_64-unknown-linux-musl

echo "==> Building static codex (aarch64-unknown-linux-musl)"
cargo build -p codex-cli --bin codex --release --target aarch64-unknown-linux-musl

echo "==> Binaries"
ls -lh target/x86_64-unknown-linux-musl/release/codex || true
ls -lh target/aarch64-unknown-linux-musl/release/codex || true

popd >/dev/null
echo "Done. Artifacts are under vendor/codex/codex-rs/target/*-unknown-linux-musl/release/codex"

