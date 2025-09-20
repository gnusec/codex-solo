架构与设计
=========

本文介绍在本仓库中如何“二次开发”：在上游 Codex 的基础上，以较小改动实现实用的 SOLO 能力，并说明成功校验与 CI/无头用法。

架构图
![Architecture](../assets/architecture.svg)

目标
- 尽量减少对上游的偏离（vendor 代码；避免侵入式修改）
- 以循环自动推进，而不是靠人工猜测
- 以“证据”定义成功（退出码、文件/输出/测试），而不是语句描述

组件
- Codex TUI（上游）：交互式控制台
- SOLO 控制器：自动继续循环，`continue_prompt`/`interval_seconds`/`exit_on_success`
- 成功校验：`done_token` 或脚本化校验 `success_cmd` / `success_sh`（退出码 0）
- 配置加载：`.codex-solo.json` 或 `CODEX_SOLO_CONFIG`
- 多实例 A/B：Runner（检测证据）/Judge（产出证据）
- 无头/CI：伪 TTY + 自启动 + 脚本化成功校验

数据流
1）用户在 TUI 输入 `/solo` 或通过环境/文件自启动
2）控制器按需插入“继续”提示；可选间隔节流
3）每轮后执行成功校验：匹配标记或外部命令/Shell 返回 0
4）成功则可选退出；否则继续循环

设计要点
- 优先使用 `success_sh` 精确给出“成功证明”（grep 报告、检查 JSON/文件）
- 将 `done_token` 设为 `""` 可禁用“打印标记”路径
- 多实例 A/B：用不同 `CODEX_SOLO_CONFIG` 解耦配置
- 无头：日志简洁；校验简短而精确

可扩展性
- 可新增校验配方（如 JSONPath、HTTP 检查等）
- CI 场景可下载发布好的 `codex` 二进制，便于自托管流水线

