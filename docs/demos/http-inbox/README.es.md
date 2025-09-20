HTTP Inbox (demo)
================

Levanta un pequeño inbox HTTP (`127.0.0.1:8787/inbox`) para que A y B envíen mensajes JSON.

Iniciar inbox
```bash
MAILBOX_DIR=mailbox python3 scripts/http-inbox/server.py
```

Enviar desde A
```bash
curl -sS -X POST http://127.0.0.1:8787/inbox \
  -H 'Content-Type: application/json' \
  -d '{"from":"A","message":"step ok","done":false}'
```

Enviar desde B (finalizado)
```bash
curl -sS -X POST http://127.0.0.1:8787/inbox \
  -H 'Content-Type: application/json' \
  -d '{"from":"B","message":"review ok","done":true}'
```

Webhooks de GitHub
- Usa un túnel (cloudflared/ngrok) para exponer `http://127.0.0.1:8787`
- Configura un webhook de GitHub (push/PR) para notificar tu inbox

