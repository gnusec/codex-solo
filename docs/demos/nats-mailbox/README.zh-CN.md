NATS 信箱（CLI）
================

使用 `nats` CLI 作为“信箱”（需要 NATS 服务器）。

A 侧订阅
```bash
nats sub duet
```

B 侧发布
```bash
nats pub duet 'review ok'
nats pub duet 'done_by_b'
```

备注
- 安装 CLI：https://github.com/nats-io/natscli
- 如需持久化可用 JetStream（streams/consumers）

