#!/usr/bin/env bash
set -euo pipefail
# Requires: redis-cli
# Usage: CHANNEL=duet ./publish.sh "review ok" [done]
CHANNEL="${CHANNEL:-duet}"
MSG="${1:-ok}"
DONE="${2:-}"
redis-cli publish "$CHANNEL" "$MSG" >/dev/null
if [ -n "$DONE" ]; then
  redis-cli publish "$CHANNEL" "done_by_b" >/dev/null
fi

