#!/usr/bin/env bash
set -euo pipefail
# Requires: SLACK_WEBHOOK_URL env var
URL="${SLACK_WEBHOOK_URL:?set SLACK_WEBHOOK_URL}"
TEXT=${1:-"review ok"}
curl -sS -X POST -H 'Content-type: application/json' --data "{\"text\": \"$TEXT\"}" "$URL" >/dev/null

