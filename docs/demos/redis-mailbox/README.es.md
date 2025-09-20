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

