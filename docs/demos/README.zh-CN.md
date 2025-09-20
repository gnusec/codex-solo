协作演示（双引擎 Duet）
=======================

本目录演示在同一项目中运行两个引擎协作：一个“写代码/实现”（A），一个“评审/测试”（B）。推荐 A/B 都用 Codex（自带 SOLO 自动推进），也可以将 B 换成其他 AI CLI（需手动运行，但遵守同样的“信箱”约定）。

模式
- 文件信箱：A 和 B 通过 `mailbox/` 下的小文件互通状态（已实现，可直接运行）
- Git 信箱（概念）：通过提交/分支传递状态，便于跨主机/远端（文末说明）

更多：其他引擎 / CLI
- 可以把 B 换成其他 AI CLI（或给 Codex 配不同“人设”），只要遵守信箱协议：读取 `a_to_b.txt`，达标时创建 `done_by_b.flag`
- 如果是两套 Codex（例：一个“实现者”、一个“严格评审者”），分别使用不同的初始提示/配置即可

PR 驱动评审（状态 + 工件）
- 参见：docs/demos/pr-checks/README.en.md

Artifacts 信箱
- 参见：docs/demos/artifacts-mailbox/README.en.md

HTTP 收件箱
- 参见：docs/demos/http-inbox/README.en.md

S3/MinIO 信箱
- 参见：docs/demos/s3-mailbox/README.en.md

SQLite 信箱
- 参见：docs/demos/db-mailbox/README.en.md

文件信箱（可运行）
目录：`samples/collab/file-mailbox`

角色
- A（Builder）：实现任务；认定完成后写 `mailbox/done_by_a.flag`，并在 `mailbox/a_to_b.txt` 记录要点
- B（Reviewer/QA）：等待 `done_by_a.flag`，运行测试/评审；满意后写 `mailbox/done_by_b.flag`，并在 `mailbox/b_to_a.txt` 留言

退出逻辑
- A 的成功：`mailbox/done_by_b.flag` 存在 → A 退出
- B 的成功：`mailbox/done_by_b.flag` 存在（由 B 自己写入）→ B 退出

运行（可选 tmux）
```bash
cd samples/collab/file-mailbox
./run-duet.sh       # Linux/macOS；加 --tmux 自动分屏
```
Windows PowerShell：
```powershell
cd samples/collab/file-mailbox
./run-duet.ps1
```

替换为其他 AI CLI？
- 保持信箱约定：B 需要读取 `mailbox/a_to_b.txt`，并在完成时写 `mailbox/done_by_b.flag`
- 启动脚本仅自动化了 Codex SOLO；非 Codex CLI 请在独立终端中运行，并遵守上述文件协议

Git 信箱（概念）
- 使用两个分支 `duet/a` 与 `duet/b`；A 推送到 `duet/a` 写入状态，B 拉取后在 `duet/b` 回写评审状态
- 也可用 CI 监听分支变更，驱动对应引擎；适合分布式/跨主机协作

Git 信箱（工作流示例）
- 参见：docs/demos/git-mailbox/README.en.md（可直接照做）
