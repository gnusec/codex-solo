صندوق SQLite
============

استخدم قاعدة بيانات SQLite ملفًا واحدًا كصندوق (جدول status).

كتابة الحالة
```bash
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/write_status.py done_by_b 1
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/write_status.py b_to_a "review ok"
```

قراءة الحالة
```bash
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py done_by_b
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py b_to_a
```

ملاحظات
- يمكن استخدام DuckDB بطريقة مماثلة
- للتعاون دون اتصال/حل تعارضات، فكّر بـ CRDTs (مثل Automerge)

تهيئة SOLO (A موصى بها)
```json
{
  "done_token": "",
  "kickoff_prompt": "نفّذ؛ اخرج عند إشارة DB بأن B انتهى.",
  "continue_prompt": "واصل حتى تصبح الحالة 1.",
  "success_sh": "MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py done_by_b | grep -q '^1$'",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
