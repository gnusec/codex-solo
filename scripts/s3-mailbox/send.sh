#!/usr/bin/env bash
set -euo pipefail
BUCKET="${BUCKET:?set BUCKET}"
KEY_PREFIX="${KEY_PREFIX:-mailbox/}"
MSG="${1:-OK}"
aws s3 cp <(printf '%s' "$MSG") "s3://$BUCKET/${KEY_PREFIX}b_to_a.txt"
aws s3 cp <(printf '1') "s3://$BUCKET/${KEY_PREFIX}done_by_b.flag"

