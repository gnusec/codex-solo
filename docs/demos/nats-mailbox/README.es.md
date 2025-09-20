Buzón NATS (CLI)
================

Usa el CLI `nats` para publicar/suscribirse como buzón (requiere servidor NATS).

Suscribirse (A)
```bash
nats sub duet
```

Publicar (B)
```bash
nats pub duet 'review ok'
nats pub duet 'done_by_b'
```

Notas
- Instalar CLI: https://github.com/nats-io/natscli
- Para durabilidad usa JetStream (streams/consumers)

