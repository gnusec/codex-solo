S3/MinIO 信箱
==============

使用对象存储作为“信箱”。

环境
```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://127.0.0.1:9000   # MinIO 可选
export BUCKET=my-mailbox
```

B 发送
```bash
KEY_PREFIX=proj1/ ./scripts/s3-mailbox/send.sh "review ok"
```

A 轮询（存在 flag 代表成功）
```bash
KEY_PREFIX=proj1/ ./scripts/s3-mailbox/poll.sh
```

备注
- 用 AWS S3 时去掉 `AWS_ENDPOINT_URL`
- 可附带 JSON 元数据并在对端解析

