#!/usr/bin/env bash
set -euo pipefail

# Push this repository to GitHub (Plan B), using a fine‑grained PAT.
# - Removes nested vendor/codex/.git so files are included in the top-level repo.
# - Initializes a repo (if needed), commits current tree, pushes main, and optional tag.
#
# Usage:
#   bash scripts/push-github.sh --repo <owner/repo> --pat-file </path/to/pat.txt> [--tag vX.Y.Z] [--force]
#
# Example:
#   bash scripts/push-github.sh --repo gnusec/codex-solo --pat-file /tmp/codex-solo-pat.txt --tag v0.1.0

repo=""
pat_file=""
tag=""
force=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) repo="$2"; shift 2 ;;
    --pat-file) pat_file="$2"; shift 2 ;;
    --tag) tag="$2"; shift 2 ;;
    --force) force=true; shift ;;
    -h|--help)
      sed -n '1,60p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

if [[ -z "$repo" || -z "$pat_file" ]]; then
  echo "Missing required --repo or --pat-file" >&2
  exit 2
fi
if [[ ! -f "$pat_file" ]]; then
  echo "PAT file not found: $pat_file" >&2
  exit 3
fi

PAT=$(cat "$pat_file")
REMOTE_URL="https://x-access-token:${PAT}@github.com/${repo}.git"

# Ensure nested vendor git is removed so files are tracked by top-level repo
if [[ -d vendor/codex/.git ]]; then
  rm -rf vendor/codex/.git
fi

# Init top-level git repo if needed
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  git init -b main >/dev/null
fi

git add -A
if ! git diff --cached --quiet; then
  git commit -m "chore: initial import with SOLO mode, docs, CI/CD" >/dev/null
fi

if git remote get-url origin >/dev/null 2>&1; then
  git remote remove origin
fi
git remote add origin "$REMOTE_URL"

echo "==> Pushing main to $repo"
set +e
git push -u origin main
rc=$?
set -e
if [[ $rc -ne 0 && "$force" == "true" ]]; then
  echo "Non fast-forward; forcing with --force-with-lease"
  git push --force-with-lease origin main
fi

if [[ -n "$tag" ]]; then
  echo "==> Pushing tag $tag"
  if ! git rev-parse "$tag" >/dev/null 2>&1; then
    git tag "$tag"
  fi
  git push origin "$tag"
fi

echo "Done. Check GitHub Actions and Releases: https://github.com/${repo}"
