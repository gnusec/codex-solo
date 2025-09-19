#!/usr/bin/env bash
set -euo pipefail

# List assets for a GitHub release using gh CLI.
# Usage:
#   scripts/list-release-assets.sh [tag]
# If no tag is provided, uses the latest release.

REPO="gnusec/codex-solo"
TAG="${1:-}"

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh (GitHub CLI) not found. Install from https://cli.github.com/" >&2
  exit 1
fi

if [[ -z "$TAG" ]]; then
  gh release view --repo "$REPO" --json url,tagName,assets \
    --jq '.url + "\n" + .tagName + "\n" + ( .assets | map(.name) | join("\n") )'
else
  gh release view "$TAG" --repo "$REPO" --json url,tagName,assets \
    --jq '.url + "\n" + .tagName + "\n" + ( .assets | map(.name) | join("\n") )'
fi

