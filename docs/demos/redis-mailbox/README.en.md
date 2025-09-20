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

Recommended SOLO config (A)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implement tasks. A bridge/subscriber sets done_by_b when B finishes.",
  "continue_prompt": "Keep going until done flag is set.",
  "success_sh": "redis-cli get done_by_b | grep -q 1",
  "interval_seconds": 15,
  "exit_on_success": true
}
```
