Buzón SQLite
============

Usa una base SQLite de un solo archivo como buzón (tabla status).

Escribir estado
```bash
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/write_status.py done_by_b 1
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/write_status.py b_to_a "review ok"
```

Leer estado
```bash
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py done_by_b
MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py b_to_a
```

Notas
- DuckDB puede usarse de forma similar
- Para edición offline/colaborativa, considera CRDTs (p. ej. Automerge)

SOLO recomendado (A)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implementar; salir cuando el estado DB indique que B terminó.",
  "continue_prompt": "Seguir hasta que el estado sea 1.",
  "success_sh": "MAILBOX_DB=mailbox.db python3 scripts/db-mailbox/read_status.py done_by_b | grep -q '^1$'",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
