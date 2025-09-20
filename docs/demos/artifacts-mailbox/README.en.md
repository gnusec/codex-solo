Artifacts Mailbox Demo
======================

Use Actions artifacts as a lightweight mailbox for B to send results back to A.

Workflow
- `.github/workflows/artifacts-mailbox-demo.yml` produces two files: `b_to_a.txt` and `done_by_b.flag`

Run
1) In Actions, trigger the workflow manually (workflow_dispatch) and optionally set a reviewer message
2) A can download the artifact `mailbox-b` via the Actions UI or `gh run download` to ingest the signal

Notes
- If you need a durable mailbox, consider Releases (release assets) or an object store (S3/MinIO)

