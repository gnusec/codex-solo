#!/usr/bin/env bash
set -euo pipefail
BUCKET="${BUCKET:?set BUCKET}"
KEY_PREFIX="${KEY_PREFIX:-mailbox/}"
TMP="${TMPDIR:-/tmp}/s3-mailbox.$$"
mkdir -p "$TMP"
while true; do
  aws s3 cp "s3://$BUCKET/${KEY_PREFIX}done_by_b.flag" "$TMP/flag" --only-show-errors && {
    aws s3 cp "s3://$BUCKET/${KEY_PREFIX}b_to_a.txt" "$TMP/msg" --only-show-errors || true
    echo "[B→A] $(cat "$TMP/msg" 2>/dev/null || true)"
    exit 0
  } || true
  sleep 5
done

