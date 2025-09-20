PR Checks Demo（状态 + 工件）
=============================

将 B 引擎视作 PR 检查：A 打开 PR 后，工作流 `.github/workflows/pr-checks-demo.yml` 运行、上传一份报告为 artifact，并打一个绿色 Check。

尝试
```bash
git checkout -b demo/pr-checks
echo "demo" > PR_CHECKS_DEMO.txt
git add PR_CHECKS_DEMO.txt && git commit -m "demo: pr checks"
git push -u origin demo/pr-checks
# 提交 PR 到 main；查看 Check 与 artifact
```

替换为真实检查
- 把占位步骤换成你的真实测试/Lint 或 AI 评审 CLI
- 可用 `actions/github-script` 生成更丰富的总结或注解

可选 SOLO 配置（本地 A）
```json
{
  "done_token": "",
  "kickoff_prompt": "实现并发起 PR；当 B 给出完成信号后退出。",
  "continue_prompt": "持续迭代，直到 B 的检查通过。",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
