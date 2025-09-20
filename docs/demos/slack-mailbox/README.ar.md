صندوق Slack (Webhook)
=====================

استخدم Incoming Webhook في Slack كصندوق بريد.

البيئة
```bash
export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
```

إرسال (B)
```bash
./scripts/slack-mailbox/send.sh "review ok"
./scripts/slack-mailbox/send.sh "done_by_b"
```

ملاحظات
- لـ Matrix/Telegram استخدم واجهات bot/webhook المماثلة

