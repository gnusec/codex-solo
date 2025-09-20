NATS Mailbox (CLI-based)
========================

Use the `nats` CLI to publish/subscribe as a mailbox (requires a running NATS server).

Subscribe (A side)
```bash
nats sub duet
```

Publish (B side)
```bash
nats pub duet 'review ok'
nats pub duet 'done_by_b'
```

Notes
- Install the CLI: https://github.com/nats-io/natscli
- For durability, consider JetStream (streams/consumers)

