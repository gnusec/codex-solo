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

