SQLite 信箱
============

用单文件 SQLite DB 作为“信箱”（status 表）。

写入状态
```bash
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/write_status.py done_by_b 1
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/write_status.py b_to_a "review ok"
```

读取状态
```bash
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py done_by_b
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py b_to_a
```

备注
- DuckDB 也可类似使用
- 离线/并协友好可考虑 CRDT（例如 Automerge）

推荐 SOLO 配置（A）
```json
{
  "done_token": "",
  "kickoff_prompt": "推进实现；当 DB 状态指示 B 完成时退出。",
  "continue_prompt": "持续推进，直到 done 状态为 1。",
  "success_sh": "MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py done_by_b | grep -q '^1$'",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
