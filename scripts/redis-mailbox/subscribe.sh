#!/usr/bin/env bash
set -euo pipefail
# Requires: redis-cli
# Usage: CHANNEL=duet ./subscribe.sh
CHANNEL="${CHANNEL:-duet}"
redis-cli subscribe "$CHANNEL" | while read -r line; do
  case "$line" in
    *"message"*) :;;
    *"done_by_b"*) echo "[B→A] done"; exit 0;;
    *) echo "[MSG] $line";;
  esac
done

