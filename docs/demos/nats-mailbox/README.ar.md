صندوق NATS (CLI)
================

استخدم CLI ‏`nats` للنشر/الاشتراك كصندوق (يتطلب خادم NATS).

الاشتراك (A)
```bash
nats sub duet
```

النشر (B)
```bash
nats pub duet 'review ok'
nats pub duet 'done_by_b'
```

ملاحظات
- تثبيت CLI: https://github.com/nats-io/natscli
- للاستمرارية استخدم JetStream (streams/consumers)

تهيئة SOLO (A موصى بها)
```json
{
  "done_token": "",
  "kickoff_prompt": "نفّذ؛ عند استقبال 'done_by_b' عبر NATS يكتب الجسر mailbox/done_by_b.flag.",
  "continue_prompt": "واصل حتى يوجد العلم محليًا.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
