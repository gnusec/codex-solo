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

Recommended SOLO config (A)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implement tasks. A small webhook bridge writes mailbox/done_by_b.flag when Slack message 'done_by_b' arrives.",
  "continue_prompt": "Keep going until done flag exists.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
