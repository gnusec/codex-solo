Collaboration Demos (Duet)
=========================

This folder shows how to run two engines in the same project to collaborate via a simple mailbox — one builds (A), the other reviews/tests (B). You can use two Codex instances (recommended) or adapt B to another AI CLI that you run manually.

Patterns
- File mailbox: A and B exchange tiny files under `mailbox/` to notify progress/done
- Git mailbox (concept): exchange via commits/branches (documented below)

Extra: other engines / CLIs
- You can replace B with another AI CLI (or Codex with a different profile) as long as it follows the mailbox protocol: read `a_to_b.txt`, create `done_by_b.flag` on success
- For two different Codex profiles (e.g., “Builder” vs “High‑rigor Reviewer”), just launch two Codex instances with different prompts/configs

File Mailbox (ready‑to‑run)
Folder: `samples/collab/file-mailbox`

Roles
- A (Builder): implements tasks; when A thinks it’s done, writes `mailbox/done_by_a.flag` and keeps a short log in `mailbox/a_to_b.txt`
- B (Reviewer/QA): waits for `done_by_a.flag`, runs tests/review, then writes `mailbox/done_by_b.flag` when satisfied and logs to `mailbox/b_to_a.txt`

How it exits
- A’s success: `mailbox/done_by_b.flag` exists → A exits
- B’s success: `mailbox/done_by_b.flag` exists (B writes it) → B exits

Run (tmux optional)
```bash
cd samples/collab/file-mailbox
./run-duet.sh           # Linux/macOS; add --tmux to auto split panes
```
On Windows PowerShell:
```powershell
cd samples/collab/file-mailbox
./run-duet.ps1
```

Use another AI CLI?
- Keep the mailbox convention: the CLI B should read `mailbox/a_to_b.txt` and write `mailbox/done_by_b.flag` when it decides work is done
- The provided launcher only automates Codex SOLO; for a non‑Codex CLI, run it in a separate terminal and follow the same mailbox file contract

Git Mailbox (concept)
- Two branches `duet/a` and `duet/b`; A pushes to `duet/a` with a status file, B reads it and pushes to `duet/b` with its status
- A CI can watch pushes and feed the counterpart engine; this pattern scales across remote runners

Git Mailbox (workflow demo)
- See: docs/demos/git-mailbox/README.en.md

PR‑driven Review (checks + artifacts)
- See: docs/demos/pr-checks/README.en.md

Artifacts Mailbox
- See: docs/demos/artifacts-mailbox/README.en.md

HTTP Inbox
- See: docs/demos/http-inbox/README.en.md

S3/MinIO Mailbox
- See: docs/demos/s3-mailbox/README.en.md

SQLite Mailbox
- See: docs/demos/db-mailbox/README.en.md

Redis Mailbox
- See: docs/demos/redis-mailbox/README.en.md

NATS Mailbox
- See: docs/demos/nats-mailbox/README.en.md

Slack Mailbox
- See: docs/demos/slack-mailbox/README.en.md
