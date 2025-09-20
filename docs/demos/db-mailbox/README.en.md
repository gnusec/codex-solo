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

Recommended SOLO config (A)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implement tasks. Exit when DB status indicates B is done.",
  "continue_prompt": "Keep going until done status is 1.",
  "success_sh": "MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py done_by_b | grep -q '^1$'",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
