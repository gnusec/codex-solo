TODO / 开发待办
================

已知问题 / Known Issues
- Codex 无法自动化“缩减上下文”（无法自动触发 /compact），在长对话或大历史时可能导致上下文溢出、回复卡顿或成本上升。
  - 影响：长任务的持续对话可能越来越慢或触达上下文上限。
  - 临时规避：
    - 手动使用 `/compact` 或新开会话/切分任务阶段。
    - 尽量把“成功校验”做成外部脚本（success_sh / success_cmd），减少对历史对话的依赖。
    - 控制“自动继续”的节奏（interval_seconds），引导阶段性总结。
  - 方向：探索在 TUI 中提供“自动提示压缩”建议；或在 SOLO 回合间注入“简要总结”提示以约束上下文增长（保持为可选、低侵入）。

短期 / Short‑term
- PR Checks 增强：在 Check Run 中添加注解/高亮（annotations），并附带 artifact 直达链接。
- 成功配方（recipes）示例库：JSONPath/HTTP/grep 组合的可复用 success_sh 片段。
- 协作 Demos 小幅打磨：为 Redis/NATS/Slack 提供最小“桥接示例”脚本（已提供；保持示例级）。

中期 / Mid‑term
- 架构文档补充：更多组件交互图（组件粒度更细的职责边界说明）。
- 无头/CI 指南：添加“最小 pipeline”样例，包含 artifact 汇总与失败快照。

备注 / Notes
- 以上为示例级 Roadmap 片段，保持“轻量、可抄用”的优先级，不做过度工程。

