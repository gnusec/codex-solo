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

