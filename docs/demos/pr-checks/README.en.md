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

