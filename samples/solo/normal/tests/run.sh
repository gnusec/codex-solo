#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SCANNER="$ROOT_DIR/tools/nlscan.lsp"

echo "[TEST] Starting temporary HTTP server on 127.0.0.1:9999"
python3 -m http.server 9999 >/tmp/http9999.log 2>&1 &
SVC_PID=$!
sleep 0.5

cleanup() {
  kill "$SVC_PID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "[TEST] Basic scan text output"
OUT1="/tmp/nlscan_out1.txt"
newlisp "$SCANNER" -t 127.0.0.1 --ports 9999,65535 -c 4 -T 1 -f text -o "$OUT1"
cat "$OUT1"
grep -E "127.0.0.1[[:space:]]+9999[[:space:]]+open" "$OUT1" >/dev/null
grep -E "127.0.0.1[[:space:]]+65535[[:space:]]+closed" "$OUT1" >/dev/null

echo "[TEST] Emit nmap integration files"
NMAP_CMDS="/tmp/nmap_cmds.sh"
NMAP_HOSTS="/tmp/nmap_hosts.txt"
newlisp "$SCANNER" -t 127.0.0.1 --ports 9999,65535 -c 2 -T 1 --emit-nmap-cmds "$NMAP_CMDS" --emit-nmap-iL "$NMAP_HOSTS" >/dev/null
grep -E "nmap .* -p .*9999.* 127.0.0.1" "$NMAP_CMDS" >/dev/null
grep -E "^127.0.0.1$" "$NMAP_HOSTS" >/dev/null

echo "[TEST] Config file and @file support"
mkdir -p "$ROOT_DIR/tests/tmp"
echo "127.0.0.1" > "$ROOT_DIR/tests/tmp/targets.txt"
cat > "$ROOT_DIR/tests/tmp/config.ini" <<EOF
targets=@$ROOT_DIR/tests/tmp/targets.txt
ports=9999,65535
concurrency=4
timeout=1
format=ndjson
EOF

OUT2="/tmp/nlscan_out2.ndjson"
newlisp "$SCANNER" -C "$ROOT_DIR/tests/tmp/config.ini" -o "$OUT2"
cat "$OUT2"
grep -E '\{"host":"127.0.0.1","port":9999,"status":"open"' "$OUT2" >/dev/null
grep -E '\{"host":"127.0.0.1","port":65535,"status":"closed"' "$OUT2" >/dev/null

echo "[TEST] All tests passed"
