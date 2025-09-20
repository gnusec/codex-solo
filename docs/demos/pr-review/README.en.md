PR Review Demo (B engine)
=========================

This demo treats the PR reviewer as engine B. A opens a PR; the workflow `.github/workflows/pr-review-demo.yml` runs and posts a review comment. Replace the placeholder step with your real checks (tests/lints) or an AI CLI.

Try it
```bash
git checkout -b demo/pr
echo "demo" > PR_DEMO.txt
git add PR_DEMO.txt && git commit -m "demo: open PR"
git push -u origin demo/pr
# open a PR to main; the workflow will comment
```

Tips
- Combine with the duet branches: let `duet/a` open PRs and this workflow acts as B in the PR space
- Store reviewer output as artifacts and link them in the comment for richer feedback

Optional SOLO config (local A)
```json
{
  "done_token": "",
  "kickoff_prompt": "Implement changes and open a PR. Wait for B's review.",
  "continue_prompt": "Keep improving until B approves.",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
