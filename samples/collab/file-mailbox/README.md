File Mailbox Duet (A/B)
=======================

This demo runs two Codex SOLO instances collaborating via files in `mailbox/`.

- A (Builder): writes progress to `mailbox/a_to_b.txt`, and when done creates `mailbox/done_by_a.flag`
- B (Reviewer/QA): reads A’s files; when satisfied, creates `mailbox/done_by_b.flag`
- Both exit when `done_by_b.flag` exists

Run
```bash
./run-duet.sh         # add --tmux to split panes if available
```
PowerShell
```powershell
./run-duet.ps1
```

Notes
- Configs: `solo-a.json` and `solo-b.json` use `success_sh` to detect `done_by_b.flag`
- You can adapt B to a different AI CLI by running it in another terminal, as long as it follows the mailbox contract
- For Git‑based mailbox, see `docs/demos/README.en.md`

