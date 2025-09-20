HTTP Inbox (डेमो)
=================

लोकल HTTP inbox (`127.0.0.1:8787/inbox`) चलाएँ, A/B JSON POST से संदेश भेजें।

स्टार्ट
```bash
MAILBOX_DIR=mailbox python3 scripts/http-inbox/server.py
```

A से भेजें
```bash
curl -sS -X POST http://127.0.0.1:8787/inbox \
  -H 'Content-Type: application/json' \
  -d '{"from":"A","message":"step ok","done":false}'
```

B से भेजें (done)
```bash
curl -sS -X POST http://127.0.0.1:8787/inbox \
  -H 'Content-Type: application/json' \
  -d '{"from":"B","message":"review ok","done":true}'
```

GitHub Webhook जोड़ें
- cloudflared/ngrok से `http://127.0.0.1:8787` एक्सपोज़ करें
- रिपो में webhook (push/PR) जोड़ें ताकि inbox ट्रिगर हो

