Slack 信箱（Webhook）
=====================

使用 Slack Incoming Webhook 作为“信箱”。

环境
```bash
export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
```

B 侧发送
```bash
./scripts/slack-mailbox/send.sh "review ok"
./scripts/slack-mailbox/send.sh "done_by_b"
```

备注
- Matrix/Telegram 可用各自的 Bot/Webhook API 类似实现

推荐 SOLO 配置（A）
```json
{
  "done_token": "",
  "kickoff_prompt": "推进实现；当 Slack 收到 'done_by_b' 时由桥接写入 mailbox/done_by_b.flag。",
  "continue_prompt": "持续推进，直到本地存在完成 flag。",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
