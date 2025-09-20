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

