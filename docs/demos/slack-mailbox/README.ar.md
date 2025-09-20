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

تهيئة SOLO (A موصى بها)
```json
{
  "done_token": "",
  "kickoff_prompt": "نفّذ؛ عند وصول 'done_by_b' عبر Slack يكتب الجسر mailbox/done_by_b.flag.",
  "continue_prompt": "واصل حتى يوجد العلم محليًا.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
