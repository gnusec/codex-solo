#!/usr/bin/env bash
set -euo pipefail

# Record a short asciinema session and convert to a GIF.
# Requirements: asciinema + agg (asciinema-agg)
# Output: assets/tui-demo.gif

CAST=${1:-demo.cast}
OUT=assets/tui-demo.gif

if ! command -v asciinema >/dev/null 2>&1; then
  echo "error: asciinema not found" >&2; exit 1
fi
if ! command -v agg >/dev/null 2>&1; then
  echo "error: agg (asciinema-agg) not found" >&2; exit 1
fi

echo "Recording to $CAST ... (Ctrl-D to finish)"
asciinema rec "$CAST"

mkdir -p assets
echo "Converting $CAST to $OUT ..."
agg --font-size 14 --frame-rate 24 --theme dracula "$CAST" "$OUT"
echo "Done: $OUT"

