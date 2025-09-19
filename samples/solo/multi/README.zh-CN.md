两个终端，一个项目目录

- 终端 A（Runner）：持续运行，直到出现凭证文件 `FINISH.txt`。
  - 使用 `CODEX_SOLO_CONFIG` 指向 `samples/solo/multi/a/solo-a.json`。
  - 工作目录：你的项目根目录。

- 终端 B（Judge）：每隔 1 分钟评估项目是否开发完成；若完成，则创建 `FINISH.txt` 作为凭证。
  - 使用 `CODEX_SOLO_CONFIG` 指向 `samples/solo/multi/b/solo-b.json`（默认不退出）。
  - 工作目录：与终端 A 相同的项目根目录。

注意事项
- 在终端 A 的配置中使用 `exit_on_success: true`，当检测到 `FINISH.txt` 存在时立即退出。
- 将终端 B 的 `done_token` 设为 `""`，避免因模型输出标记而提前停止。
- 为避免两个进程争用同一 `.codex-solo.json`，使用 `CODEX_SOLO_CONFIG=/path/to/solo.json` 指定各自的 SOLO 配置文件（相对路径相对工作目录解析）。

可选：让终端 B 在完成时也自动退出
- 方案一（给 B 单独的成功凭证）：
  - 配置 B 的成功检查为 `success_sh: "test -f JUDGE_DONE.txt"`，并开启 `exit_on_success: true`。
  - 当 B 判断项目完成时，同时创建：
    - `FINISH.txt`（通知 A 停止），以及
    - `JUDGE_DONE.txt`（通知 B 自己退出）。
  - 示例配置：`samples/solo/multi/b/solo-b-exit.json`。
- 方案二（复用 FINISH.txt）：
  - 将 B 的成功检查设为 `success_sh: "test -f FINISH.txt"`，并开启 `exit_on_success: true`。
  - 由于 B 自己写入 `FINISH.txt`，它也会在创建后观察到成功并退出。

快速启动
- 终端 A（Runner）
  - `CODEX_SOLO_CONFIG=$PWD/samples/solo/multi/a/solo-a.json CODEX_SOLO_AUTOSTART=1 ./codex`
  - CODEX_SOLO_CONFIG=$PWD/solo-a.json CODEX_SOLO_AUTOSTART=1 ./codex-solo --ask-for-approval never --sandbox danger-full-access --model gpt-5 --config model_reasoning_effort=high
- 终端 B（保持运行）
  - `CODEX_SOLO_CONFIG=$PWD/samples/solo/multi/b/solo-b.json CODEX_SOLO_AUTOSTART=1 ./codex`
- 终端 B（完成时退出）
  - `CODEX_SOLO_CONFIG=$PWD/samples/solo/multi/b/solo-b-exit.json CODEX_SOLO_AUTOSTART=1 ./codex` 
  - CODEX_SOLO_CONFIG=$PWD/solo-b-exit.json CODEX_SOLO_AUTOSTART=1 ./codex-solo --ask-for-approval never --sandbox danger-full-access --model gpt-5 --config model_reasoning_effort=high

脚本一键启动
- 在该目录直接一键：
  - `./run-dual.sh --tmux`（若安装 tmux，会开双窗；否则后台运行并写入日志）
  - 或 `./run-dual.sh -C /path/to/project --tmux` 指定项目目录
- 让 B 在完成时也退出：
  - `./run-dual.sh --tmux --b-exit`
- 自定义二进制或参数：
  - `CODEX_BIN=/abs/path/to/codex EXTRA_CLI_FLAGS="--ask-for-approval never --sandbox danger-full-access --model gpt-5 --config model_reasoning_effort=high" ./run-dual.sh --tmux`
