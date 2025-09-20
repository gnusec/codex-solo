Slack Mailbox (webhook)
=======================

Use a Slack Incoming Webhook as a mailbox.

Env
```bash
export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
```

Send (B side)
```bash
./scripts/slack-mailbox/send.sh "review ok"
./scripts/slack-mailbox/send.sh "done_by_b"
```

Notes
- For Matrix/Telegram, use their respective bot/webhook APIs similarly

