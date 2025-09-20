Slack 信箱（Webhook）
=====================

使用 Slack Incoming Webhook 作为“信箱”。

环境
```bash
export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
```

B 侧发送
```bash
./scripts/slack-mailbox/send.sh "review ok"
./scripts/slack-mailbox/send.sh "done_by_b"
```

备注
- Matrix/Telegram 可用各自的 Bot/Webhook API 类似实现

