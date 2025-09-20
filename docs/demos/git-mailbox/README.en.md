Git Mailbox Duet (A/B)
======================

This demo uses two branches as a mailbox between A (builder) and B (reviewer). A pushes status to `duet/a`; a GitHub Action acts as B and writes its review + `mailbox/done_by_b.flag` to `duet/b`.

Bootstrap
```bash
# from your repo root
git checkout -b duet/a
mkdir -p mailbox
echo "initial plan" > mailbox/a_to_b.txt
git add mailbox/a_to_b.txt
git commit -m "duet: A → B initial message"
git push -u origin duet/a
```

What happens
- The workflow `.github/workflows/duet-git-mailbox.yml` triggers on pushes to `duet/a`
- It creates/updates `duet/b` with:
  - `mailbox/b_to_a.txt`: the reviewer note
  - `mailbox/done_by_b.flag`: a simple success indicator

Notes
- Replace the workflow with a custom reviewer if you want a real AI CLI on B; this sample just demonstrates the branch‑based mailbox
- File‑mailbox duet (no Git) is also available: `samples/collab/file-mailbox`

