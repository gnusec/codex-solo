صندوق Redis
===========

صندوق بريد خفيف عبر Redis Pub/Sub.

المتطلبات
- redis-server و redis-cli محليًا

الاشتراك (A)
```bash
CHANNEL=duet ./scripts/redis-mailbox/subscribe.sh
```

النشر (B)
```bash
CHANNEL=duet ./scripts/redis-mailbox/publish.sh "review ok"
CHANNEL=duet ./scripts/redis-mailbox/publish.sh "done" done
```

ملاحظات
- الرسائل طيّارة؛ للاستمرارية استخدم Streams أو صندوق DB
- يمكن إرسال JSON وتحليله عند المستلم

تهيئة SOLO (A موصى بها)
```json
{
  "done_token": "",
  "kickoff_prompt": "نفّذ؛ يضبط الاشتراك/الجسر done_by_b عند انتهاء B.",
  "continue_prompt": "واصل حتى يصبح العلم 1.",
  "success_sh": "redis-cli get done_by_b | grep -q 1",
  "interval_seconds": 15,
  "exit_on_success": true
}
```
