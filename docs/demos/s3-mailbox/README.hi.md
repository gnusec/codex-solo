S3/MinIO मेलबॉक्स
===================

ऑब्जेक्ट स्टोर को मेलबॉक्स की तरह उपयोग करें।

Env
```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://127.0.0.1:9000   # MinIO
export BUCKET=my-mailbox
```

B से भेजें
```bash
KEY_PREFIX=proj1/ ./scripts/s3-mailbox/send.sh "review ok"
```

A पोल करें (flag होने पर सफलता)
```bash
KEY_PREFIX=proj1/ ./scripts/s3-mailbox/poll.sh
```

नोट्स
- AWS S3 के लिए `AWS_ENDPOINT_URL` निकालें
- JSON मेटाडेटा जोड़कर रिसीवर साइड पर parse कर सकते हैं

