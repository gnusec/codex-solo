Buzón Redis
===========

Mailbox ligero con Redis Pub/Sub.

Requisitos
- redis-server y redis-cli locales

Suscribirse (lado A)
```bash
CHANNEL=duet ./scripts/redis-mailbox/subscribe.sh
```

Publicar (lado B)
```bash
CHANNEL=duet ./scripts/redis-mailbox/publish.sh "review ok"
CHANNEL=duet ./scripts/redis-mailbox/publish.sh "done" done
```

Notas
- Mensajes efímeros; para persistencia usa Streams o buzón DB
- Puedes publicar JSON y parsearlo en el receptor

SOLO recomendado (A)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implementar; un puente/subscriptor fija done_by_b cuando B termina.",
  "continue_prompt": "Seguir hasta que el flag sea 1.",
  "success_sh": "redis-cli get done_by_b | grep -q 1",
  "interval_seconds": 15,
  "exit_on_success": true
}
```
