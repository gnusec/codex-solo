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

