语言：简体中文（当前） · English · Español · العربية · हिन्दी
- English: ../docs/README.en.md
- Español: ../docs/README.es.md
- العربية: ../docs/README.ar.md
- हिन्दी: ../docs/README.hi.md

# Codex SOLO 模式 — 快速上手

简介
- SOLO 会在无需人工交互的前提下持续推进，直到满足“成功条件”。
- 在 TUI 中用 `/solo` 切换，也可设置开关开机自启。

通过 `.codex-solo.json` 配置（或通过环境变量 `CODEX_SOLO_CONFIG` 指定其他路径）
- kickoff_prompt：启动时的主题/任务（可选）
- done_token：模型打印的成功标记（默认 `[SOLO_DONE]`）
   - 若将 `done_token` 设为空字符串 `""`，SOLO 不会在 `continue_prompt` 后附加“请打印标记 …”的提示；即不会引导模型打印任何完成标记。
- continue_prompt：每轮继续提示的文本
- success_cmd：命令（argv 形式），退出码为 0 视为成功
- success_sh：Shell 片段，退出码为 0 视为成功
- exit_on_success：布尔值；为 true 时，在达到成功条件后退出 CLI
- interval_seconds：数字；两次自动继续之间的间隔（秒），例如 60

示例
1）只给主题，由模型自行判断完成（通过标记）
{
  "kickoff_prompt": "实现一个 CLI，读取 CSV 输出 JSON。最后请打印 [SOLO_DONE]",
  "done_token": "[SOLO_DONE]",
  "continue_prompt": "继续"
}

2）主题 + 明确成功校验（命令）
{
  "kickoff_prompt": "补全实现并让测试通过",
  "success_cmd": ["pytest", "-q"],
  "continue_prompt": "继续（迭代直到测试通过）"
}

3）主题 + 明确成功校验（Shell）
{
  "kickoff_prompt": "实现并确保测试报告显示 42 passed",
  "success_sh": "pytest -q | tee /tmp/pytest.out >/dev/null && grep -q '42 passed' /tmp/pytest.out",
  "continue_prompt": "继续（直到报告精确显示 42 passed）",
  "exit_on_success": true
}

开机自启 SOLO
- 环境变量：`CODEX_SOLO_AUTOSTART=1 ./codex`
- 配置文件：在 `.codex-solo.json` 中加入 `"autostart": true`（若同时存在，环境变量优先生效）
- 可选：成功后退出，设置 `CODEX_SOLO_EXIT_ON_SUCCESS=1`（或在 `.codex-solo.json` 中加入 `exit_on_success: true`）
- 可选：指定配置文件路径，设置 `CODEX_SOLO_CONFIG=/path/to/solo.json`（相对路径相对于工作目录解析）
 - 可选：设置轮询间隔，`CODEX_SOLO_INTERVAL_SECONDS=60`（或在 `.codex-solo.json` 中加入 `interval_seconds: 60`）

构建（Linux 静态 musl）
- 先安装目标：`rustup target add x86_64-unknown-linux-musl aarch64-unknown-linux-musl`
- 执行：`bash scripts/build-static.sh`

深入原理
- 详见：../docs/SOLO.zh-CN.md

运行
- `cd vendor/codex/codex-rs && cargo build -p codex-cli --release`
- 运行 `./vendor/codex/codex-rs/target/release/codex`，在聊天中输入 `/solo` 或使用自启。
