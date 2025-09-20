HTTP Inbox Demo
===============

Run a tiny local HTTP inbox (`127.0.0.1:8787/inbox`) so A and B can POST JSON messages as a mailbox.

Start inbox
```bash
MAILBOX_DIR=mailbox python3 scripts/http-inbox/server.py
```

Post from A (example)
```bash
curl -sS -X POST http://127.0.0.1:8787/inbox \
  -H 'Content-Type: application/json' \
  -d '{"from":"A","message":"step ok","done":false}'
```

Post from B (done)
```bash
curl -sS -X POST http://127.0.0.1:8787/inbox \
  -H 'Content-Type: application/json' \
  -d '{"from":"B","message":"review ok","done":true}'
```

Connect GitHub Webhooks
- Use a tunnel (e.g., cloudflared, ngrok) to expose `http://127.0.0.1:8787`
- Add a GitHub webhook (push/PR events) to notify your inbox and trigger B locally

Recommended SOLO config (A)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implement tasks and log to mailbox/a_to_b.txt. Wait for B to POST done.",
  "continue_prompt": "Keep going until done_by_b.flag exists.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
