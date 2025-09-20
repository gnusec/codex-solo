SQLite Mailbox
==============

Use a single‑file SQLite DB as a mailbox (status table).

Write status
```bash
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/write_status.py done_by_b 1
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/write_status.py b_to_a "review ok"
```

Read status
```bash
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py done_by_b
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py b_to_a
```

Notes
- DuckDB could be used similarly
- For offline/collab edits, consider CRDTs (e.g., Automerge) as a higher‑level mailbox

