Capture and Update the TUI Demo
================================

This shows how to record a short TUI demo and publish it as a small GIF.

Option A — asciinema → GIF (recommended)
- Install tools:
  - macOS: `brew install asciinema asciinema-agg`
  - Ubuntu: `sudo apt-get install -y asciinema` and install agg: `curl -fsSL https://github.com/asciinema/agg/releases/latest/download/agg-linux-x64 -o /usr/local/bin/agg && chmod +x /usr/local/bin/agg`
- Record (Ctrl-D or exit to finish):
  - `asciinema rec demo.cast`
  - Run: `./vendor/codex/codex-rs/target/release/codex`, type `/solo`, show success
- Convert to GIF:
  - `agg --font-size 14 --frame-rate 24 --theme dracula demo.cast assets/tui-demo.gif`
- Commit:
  - `git add assets/tui-demo.gif && git commit -m "docs: add real TUI demo gif" && git push`

Option B — plain screen recorder
- Use any recorder (OBS, Kap, etc.), trim to ~5–10s
- Export to GIF and save as `assets/tui-demo.gif`

Notes
- Keep it short and readable (80–100 columns wide)
- Avoid showing tokens/keys
- After replacing the file, README will automatically show the new GIF

