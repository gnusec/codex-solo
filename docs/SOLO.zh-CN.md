# SOLO 模式 — 原理与技术说明

本文档深入说明 vendored Codex CLI 中 SOLO 模式的实现原理、配置入口、关键代码位置与常见陷阱。

## 设计目标

- 在无需人工交互的前提下，自动推进回合（turn），直到满足“成功条件”。
- 支持两类成功校验：
  - 基于模型输出的完成标记（done token）。
  - 基于 shell/命令返回码的明确证明（success_cmd / success_sh）。
- 可配置自动继续提示（continue_prompt）、完成即退出（exit_on_success）、以及周期间隔（interval_seconds）。
- 支持通过环境变量覆盖 SOLO 配置路径，使多个实例在同一工作目录下各自使用不同配置文件。

## 配置入口与环境变量

- 默认配置文件：`<cwd>/.codex-solo.json`。
- 覆盖路径（优先）：`CODEX_SOLO_CONFIG=/path/to/solo.json`
  - 若是相对路径，以 `<cwd>` 解析。

配置字段（JSON）：
- `autostart` (bool)：进入会话后自动启用 SOLO；也可用 `CODEX_SOLO_AUTOSTART=1`。
- `kickoff_prompt` (string)：进入 SOLO 时的初始提示（可选）。
- `continue_prompt` (string)：每轮继续的提示文本。
- `done_token` (string)：完成标记（默认 `"[SOLO_DONE]"`）。若设为 `""`，不再引导模型打印任何标记。
- `success_cmd` (array[string])：argv 形式命令；退出码为 0 视为成功。
- `success_sh` (string)：shell 片段；退出码为 0 视为成功（Linux/macOS：`bash -lc`；Windows：`cmd /C`）。
- `exit_on_success` (bool)：为 true 时，判定成功后直接退出 CLI；也可用 `CODEX_SOLO_EXIT_ON_SUCCESS=1`。
- `interval_seconds` (number)：两次自动继续的间隔（秒）；也可用 `CODEX_SOLO_INTERVAL_SECONDS=60`。

## 关键代码结构（tui）

文件：`vendor/codex/codex-rs/tui/src/chatwidget.rs`

- 状态字段（`struct ChatWidget`）：
  - `solo_active: bool`
  - `solo_done_token: String`
  - `solo_continue_prompt: String`
  - `solo_success_cmd: Option<Vec<String>>`
  - `solo_success_sh: Option<String>`
  - `solo_exit_on_success: bool`
  - `solo_interval_seconds: Option<u64>`
  - `last_agent_message: Option<String>`

- 配置解析：
  - `load_solo_config_file()`
    - 读取 `CODEX_SOLO_CONFIG` 或 `<cwd>/.codex-solo.json`。
    - 反序列化为 `SoloConfigFile`。

- 自动启用：
  - `maybe_autostart_solo()`
    - 环境变量 `CODEX_SOLO_AUTOSTART` 为真则启用；否则读取配置 `autostart`。

- 启用 SOLO：
  - `enable_solo_mode()`
    - 应用配置字段（done_token / continue_prompt / success_cmd / success_sh / exit_on_success / interval_seconds）。
    - 环境变量覆盖 `exit_on_success`、`interval_seconds`。
    - 将审批/沙箱切换为低摩擦模式：`AskForApproval::OnFailure` + `WorkspaceWrite`。
    - 若存在 `kickoff_prompt`，在空闲时立即发送（或排队）。

- 回合结束钩子：
  - `on_solo_after_task()`
    - 先调用 `solo_success_reached()`：
      1) 若配置了 `success_cmd`，以 argv 方式执行，退出码 0 视为成功。
      2) 若配置了 `success_sh`，以 shell 执行，退出码 0 视为成功。
      3) 否则检查 `last_agent_message` 是否包含 `solo_done_token`（且 token 非空）。
    - 成功：
      - 关闭 SOLO；若 `solo_exit_on_success` 为真，则发送 `ExitRequest` 退出。
    - 未成功：
      - 若 `solo_interval_seconds` 有值且 > 0，则使用 `tokio::time::sleep()` 异步延迟后，发送下一轮 `continue_prompt`。
      - 否则，立即把继续提示排队到 `queued_user_messages`。

- 继续提示文案：
  - `build_solo_continue_message()`
    - 当 `solo_done_token` 非空时，会在 `continue_prompt` 后附加“完成时请输出标记 …”提示；
    - 当 `solo_done_token` 为 `""` 时，不附加任何提示，避免诱导模型打印标记。

- 外部检查实现：
  - `run_check_argv()` / `run_check_shell()`：封装命令/脚本执行并读取退出码。

## 运行时事件流概述（TUI）

1. 会话初始化 → `maybe_autostart_solo()` 判断是否启用 SOLO。
2. 用户/系统提交 `UserInput`（可能来自 `kickoff_prompt` 或后续的继续提示）。
3. 模型流式输出；最终以 `TaskComplete` 事件结束一轮。
4. `on_solo_after_task()`：判断成功或安排下一轮（可延迟）。
5. 成功时退出（可选）；未成功时继续循环。

## 样例与场景

- 多实例监控（`samples/solo/multi/`）
  - 终端 A（Runner）：使用 `a/solo-a.json`，通过 `success_sh: "test -f FINISH.txt"` 轮询，完成即退出。
  - 终端 B（Judge）：使用 `b/solo-b.json`，每隔 60s 评估并在完成时写入凭证文件。也可使用 `b/solo-b-exit.json`，在创建自有 `JUDGE_DONE.txt` 后自行退出。
  - 两个进程共享同一项目目录，但通过 `CODEX_SOLO_CONFIG` 指向不同 SOLO 配置文件，互不干扰。

## 常见陷阱与建议

- “输出完成标记”诱导：
  - 旧版在 `continue_prompt` 后会附加“请打印标记 …”。当 `done_token` 为 `""` 时，现在不会再附加，避免模型自行选择如 `[SOLO_DONE]` 等标记。

- 配置文件路径冲突：
  - 多进程场景务必使用 `CODEX_SOLO_CONFIG` 指向各自配置，不要共用 `<cwd>/.codex-solo.json`。

- Shell 成功校验的可移植性：
  - `success_sh` 在 Linux/macOS 下使用 `bash -lc`；Windows 使用 `cmd /C`。按平台选择脚本语法。

- 工作目录与相对路径：
  - `success_sh`/`success_cmd` 中的相对路径以 `<cwd>` 解析，请确保两个进程使用相同工作目录来共享凭证文件。

## 相关代码清单（快速索引）

- `tui/src/chatwidget.rs`
  - `struct ChatWidget` 中 SOLO 字段
  - `load_solo_config_file()`
  - `maybe_autostart_solo()` / `enable_solo_mode()`
  - `on_solo_after_task()` / `solo_success_reached()`
  - `build_solo_continue_message()`
  - `run_check_argv()` / `run_check_shell()`

（可配合 `rg -n "SOLO|solo_" vendor/codex/codex-rs` 在仓库内快速检索相关位置。）

