صندوق S3/MinIO
===============

استخدم مخزن كائنات كصندوق بريد.

البيئة
```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://127.0.0.1:9000   # لـ MinIO اختياري
export BUCKET=my-mailbox
```

إرسال (B)
```bash
KEY_PREFIX=proj1/ ./scripts/s3-mailbox/send.sh "review ok"
```

استطلاع (A)
```bash
KEY_PREFIX=proj1/ ./scripts/s3-mailbox/poll.sh
```

ملاحظات
- مع AWS S3 احذف `AWS_ENDPOINT_URL`
- يمكن إرفاق JSON metadata وتحليلها في الطرف الآخر

