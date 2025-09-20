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

推荐 SOLO 配置（A）
```json
{
  "done_token": "",
  "kickoff_prompt": "推进实现；当 NATS 收到 done_by_b 时由桥接脚本写入 mailbox/done_by_b.flag。",
  "continue_prompt": "持续推进，直到本地存在完成 flag。",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
