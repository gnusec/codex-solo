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

