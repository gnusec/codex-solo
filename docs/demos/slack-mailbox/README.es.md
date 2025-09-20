Buzón Slack (Webhook)
=====================

Usa un Incoming Webhook de Slack como buzón.

Entorno
```bash
export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
```

Enviar (B)
```bash
./scripts/slack-mailbox/send.sh "review ok"
./scripts/slack-mailbox/send.sh "done_by_b"
```

Notas
- Para Matrix/Telegram usa sus APIs de bot/webhook de forma similar

