NATS मेलबॉक्स (CLI)
===================

`nats` CLI से पब्लिश/सब्सक्राइब मेलबॉक्स (NATS सर्वर आवश्यक)।

A सब्सक्राइब करे
```bash
nats sub duet
```

B पब्लिश करे
```bash
nats pub duet 'review ok'
nats pub duet 'done_by_b'
```

नोट्स
- CLI इंस्टॉल: https://github.com/nats-io/natscli
- स्थायित्व हेतु JetStream (streams/consumers)

