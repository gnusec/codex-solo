S3/MinIO Mailbox
================

Use an object store as a mailbox.

Env
```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://127.0.0.1:9000   # for MinIO
export BUCKET=my-mailbox
```

B sends
```bash
KEY_PREFIX=proj1/ ./scripts/s3-mailbox/send.sh "review ok"
```

A polls (success when flag exists)
```bash
KEY_PREFIX=proj1/ ./scripts/s3-mailbox/poll.sh
```

Notes
- For AWS S3 remove `AWS_ENDPOINT_URL`
- You can add metadata JSON and parse it on the other side

