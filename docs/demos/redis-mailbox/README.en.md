Redis Mailbox
=============

Lightweight mailbox via Redis Pub/Sub.

Prereq
- redis-server and redis-cli available locally

Subscribe (A side)
```bash
CHANNEL=duet ./scripts/redis-mailbox/subscribe.sh
```

Publish (B side)
```bash
CHANNEL=duet ./scripts/redis-mailbox/publish.sh "review ok"
CHANNEL=duet ./scripts/redis-mailbox/publish.sh "done" done
```

Notes
- Messages are ephemeral; for persistence use Streams or a DB mailbox
- You can include JSON payloads and parse them on the receiver

