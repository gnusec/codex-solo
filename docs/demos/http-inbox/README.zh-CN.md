HTTP 收件箱 Demo
=================

在本地起一个极简 HTTP inbox（`127.0.0.1:8787/inbox`），A/B 用 JSON POST 作为“信箱”。

启动 inbox
```bash
MAILBOX_DIR=mailbox python3 scripts/http-inbox/server.py
```

从 A 发送
```bash
curl -sS -X POST http://127.0.0.1:8787/inbox \
  -H 'Content-Type: application/json' \
  -d '{"from":"A","message":"step ok","done":false}'
```

从 B 发送（完成）
```bash
curl -sS -X POST http://127.0.0.1:8787/inbox \
  -H 'Content-Type: application/json' \
  -d '{"from":"B","message":"review ok","done":true}'
```

接入 GitHub Webhook
- 用隧道（cloudflared/ngrok）暴露 `http://127.0.0.1:8787`
- 新建仓库 Webhook（push/PR），通知你的 inbox 触发本地/远端 B

推荐 SOLO 配置（A）
```json
{
  "done_token": "",
  "kickoff_prompt": "推进实现并在 mailbox/a_to_b.txt 记录要点；等待 B 通过 HTTP 标记完成。",
  "continue_prompt": "持续推进，直到存在 done_by_b.flag。",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
