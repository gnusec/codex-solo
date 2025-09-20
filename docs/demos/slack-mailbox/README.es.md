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

SOLO recomendado (A)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implementar; un puente escribe mailbox/done_by_b.flag cuando llegue 'done_by_b' en Slack.",
  "continue_prompt": "Seguir hasta que exista el flag.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
