PR Checks Demo (status + artifact)
==================================

Treat engine B as a PR checker: when A opens a PR, the workflow `.github/workflows/pr-checks-demo.yml` runs, uploads a small report as an artifact, and sets a green check.

Try
```bash
git checkout -b demo/pr-checks
echo "demo" > PR_CHECKS_DEMO.txt
git add PR_CHECKS_DEMO.txt && git commit -m "demo: pr checks"
git push -u origin demo/pr-checks
# open PR to main; see the check + artifact
```

Replace with real checks
- Swap the placeholder step for your real tests/lints or an AI reviewer CLI
- You can parse logs and attach a richer summary or annotations via `actions/github-script`

Optional SOLO config (local A)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implement and open a PR. Exit when B signals done.",
  "continue_prompt": "Keep iterating until B's checks pass.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
