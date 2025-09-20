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

Recommended SOLO config (A)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implement tasks. A small bridge writes mailbox/done_by_b.flag when NATS receives done_by_b.",
  "continue_prompt": "Keep going until done flag exists.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
