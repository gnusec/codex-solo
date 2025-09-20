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

تهيئة SOLO (A موصى بها)
```json
{
  "done_token": "",
  "kickoff_prompt": "نفّذ؛ اخرج عند وجود إشارة B في S3.",
  "continue_prompt": "استطلع S3 حتى يظهر الـ flag.",
  "success_sh": "aws s3 ls s3://$BUCKET/${KEY_PREFIX:-mailbox/}done_by_b.flag >/dev/null 2>&1",
  "interval_seconds": 30,
  "exit_on_success": true
}
```
