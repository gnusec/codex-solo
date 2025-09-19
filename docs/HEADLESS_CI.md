Headless SOLO in CI (Experimental)
==================================

This shows how to run Codex SOLO non-interactively in GitHub Actions by autostarting SOLO and allocating a pseudo‑TTY so the TUI can initialize.

Notes
- Prefer short runs with clear `success_cmd`/`success_sh` that exit quickly on success.
- Use `script` to provide a TTY. Avoid long, noisy logs.

Example Workflow
```yaml
name: Headless SOLO (demo)
on:
  workflow_dispatch:

jobs:
  solo:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Download codex binary from latest release
        run: |
          set -euo pipefail
          URL=$(curl -s https://api.github.com/repos/gnusec/codex-solo/releases/latest | jq -r '.assets[] | select(.name|endswith("x86_64-unknown-linux-gnu")) | .browser_download_url')
          curl -L "$URL" -o codex && chmod +x codex
      - name: Provide SOLO config
        run: |
          cat > .codex-solo.json << 'JSON'
          {
            "kickoff_prompt": "Run lint + tests and fix issues",
            "success_sh": "npm ci && npm test --silent",
            "continue_prompt": "continue (fix all until green)",
            "exit_on_success": true,
            "interval_seconds": 20,
            "autostart": true
          }
          JSON
      - name: Run SOLO headless (allocate TTY)
        env:
          CODEX_SOLO_AUTOSTART: "1"
        run: |
          script -q -e -c "./codex" /dev/null || true
```

Caveats
- The interactive TUI will render to the pseudo‑TTY; logs will include its output. Use short prompts and precise checks.
- For complex scenarios, prefer driving Codex locally and only uploading artifacts to CI.

