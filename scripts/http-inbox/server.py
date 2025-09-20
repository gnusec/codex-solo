#!/usr/bin/env python3
import http.server, json, os, pathlib

MAILBOX = pathlib.Path(os.environ.get('MAILBOX_DIR', 'mailbox'))
MAILBOX.mkdir(parents=True, exist_ok=True)

class Handler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path != '/inbox':
            self.send_response(404); self.end_headers(); return
        length = int(self.headers.get('Content-Length', '0'))
        body = self.rfile.read(length)
        try:
            payload = json.loads(body.decode('utf-8'))
        except Exception:
            self.send_response(400); self.end_headers(); self.wfile.write(b'invalid json'); return
        # Expect {from: 'A|B', message: '...', done: bool}
        sender = payload.get('from', 'unknown')
        msg = payload.get('message', '')
        done = bool(payload.get('done', False))
        # Write message
        (MAILBOX / f"{sender.lower()}_to_peer.txt").write_text(str(msg))
        if done:
            (MAILBOX / 'done_by_peer.flag').write_text('1')
        self.send_response(200); self.end_headers(); self.wfile.write(b'OK')

if __name__ == '__main__':
    http.server.ThreadingHTTPServer(('127.0.0.1', 8787), Handler).serve_forever()

