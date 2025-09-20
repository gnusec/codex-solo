HTTP Inbox (تجريبي)
===================

خادم HTTP صغير (`127.0.0.1:8787/inbox`) لإرسال رسائل JSON بين A وB.

تشغيل الخادم
```bash
MAILBOX_DIR=mailbox python3 scripts/http-inbox/server.py
```

إرسال من A
```bash
curl -sS -X POST http://127.0.0.1:8787/inbox \
  -H 'Content-Type: application/json' \
  -d '{"from":"A","message":"step ok","done":false}'
```

إرسال من B (انتهى)
```bash
curl -sS -X POST http://127.0.0.1:8787/inbox \
  -H 'Content-Type: application/json' \
  -d '{"from":"B","message":"review ok","done":true}'
```

Webhooks (GitHub)
- استخدم نفقًا (cloudflared/ngrok) لكشف `http://127.0.0.1:8787`
- أضف Webhook (push/PR) لإشعار الخادم

تهيئة SOLO (A موصى بها)
```json
{
  "done_token": "",
  "kickoff_prompt": "نفّذ وسجّل في mailbox/a_to_b.txt؛ انتظر أن يرسل B إشارة done عبر HTTP.",
  "continue_prompt": "واصل حتى يوجد done_by_b.flag.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
