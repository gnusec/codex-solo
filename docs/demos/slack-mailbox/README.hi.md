Slack मेलबॉक्स (Webhook)
========================

Slack Incoming Webhook को मेलबॉक्स की तरह उपयोग करें।

Env
```bash
export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
```

B से भेजें
```bash
./scripts/slack-mailbox/send.sh "review ok"
./scripts/slack-mailbox/send.sh "done_by_b"
```

नोट्स
- Matrix/Telegram के लिए संबंधित bot/webhook APIs का उपयोग करें

