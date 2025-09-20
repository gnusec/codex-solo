Redis 信箱
==========

通过 Redis Pub/Sub 作为轻量“信箱”。

前置
- 本地可用 redis-server 与 redis-cli

A 侧订阅
```bash
CHANNEL=duet ./scripts/redis-mailbox/subscribe.sh
```

B 侧发布
```bash
CHANNEL=duet ./scripts/redis-mailbox/publish.sh "review ok"
CHANNEL=duet ./scripts/redis-mailbox/publish.sh "done" done
```

备注
- 消息易失；如需持久化请用 Streams 或 DB 信箱
- 可发送 JSON 并在接收端解析

推荐 SOLO 配置（A）
```json
{
  "done_token": "",
  "kickoff_prompt": "推进实现；由订阅/桥接脚本在 B 完成时设置 done_by_b。",
  "continue_prompt": "持续推进，直到 done 标志为 1。",
  "success_sh": "redis-cli get done_by_b | grep -q 1",
  "interval_seconds": 15,
  "exit_on_success": true
}
```
