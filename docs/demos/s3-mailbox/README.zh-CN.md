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

推荐 SOLO 配置（A）
```json
{
  "done_token": "",
  "kickoff_prompt": "推进实现；B 通过 S3 写入完成信号后退出。",
  "continue_prompt": "轮询 S3 直到出现完成 flag。",
  "success_sh": "aws s3 ls s3://$BUCKET/${KEY_PREFIX:-mailbox/}done_by_b.flag >/dev/null 2>&1",
  "interval_seconds": 30,
  "exit_on_success": true
}
```
