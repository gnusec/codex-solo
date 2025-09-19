入群 / Discussions: https://github.com/gnusec/codex-solo/discussions

语言 / Languages:
- 简体中文 (当前)
- English: docs/README.en.md
- Español: docs/README.es.md
- العربية: docs/README.ar.md
- हिन्दी: docs/README.hi.md

# Codex SOLO Mode (vendored)

一个极简 README，去掉花哨 ASCII。SOLO 会自动连续工作，直到“成功检查”通过。

## Quick Start
- 构建：`cd vendor/codex/codex-rs && cargo build -p codex-cli --release`
- 运行：`./vendor/codex/codex-rs/target/release/codex`
- 开启 SOLO：在 TUI 输入 `/solo`，或设置环境变量 `CODEX_SOLO_AUTOSTART=1`
- 多实例配置：为不同控制台设置 `CODEX_SOLO_CONFIG=/path/to/solo.json`

## Minimal Config (.codex-solo.json)
```
{
  "kickoff_prompt": "实现并让测试通过",
  "continue_prompt": "继续",
  "success_cmd": ["pytest", "-q"],
  "exit_on_success": true,
  "interval_seconds": 30
}
```

或使用脚本化证明（退出码为 0 代表成功）：
```
{ "success_sh": "test -f FINISH.txt" }
```

## Key Options
- `success_cmd` / `success_sh`：成功由退出码 0 判定
- `done_token`：默认 `[SOLO_DONE]`；设为 "" 可避免引导模型输出标记
- `exit_on_success`：成功后退出 CLI
- `interval_seconds`：自动继续之间的延迟

## Downloads
- Releases：https://github.com/gnusec/codex-solo/releases

## Docs
- 多语言上手：`docs/README.*.md`
- SOLO 深入：`docs/SOLO.*.md`
- 路线图：`docs/ROADMAP.md`

## License
见 `LICENSE`
