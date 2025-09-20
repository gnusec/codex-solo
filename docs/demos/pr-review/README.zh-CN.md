PR 评审 Demo（B 引擎）
=====================

将 PR 审查视为 B 引擎：A 发起 PR；工作流 `.github/workflows/pr-review-demo.yml` 运行并自动发表评论。把占位步骤替换为真实测试/Lint/或 AI CLI 即可。

尝试
```bash
git checkout -b demo/pr
echo "demo" > PR_DEMO.txt
git add PR_DEMO.txt && git commit -m "demo: open PR"
git push -u origin demo/pr
# 提交 PR 到 main；工作流会自动评论
```

提示
- 可结合“duet/a” 分支：由 A 打 PR，而该工作流扮演 B
- 可将评审输出上传为 artifacts，并在评论里附链接

可选 SOLO 配置（本地 A）
```json
{
  "done_token": "",
  "kickoff_prompt": "实现并发起 PR；等待 B 评审信号。",
  "continue_prompt": "持续完善，直到 B 确认。",
  "success_sh": "test -f mailbox/done_by_b.flag",
  "interval_seconds": 20,
  "exit_on_success": true
}
```
