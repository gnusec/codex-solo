Git 信箱 Duet（A/B）
===================

使用两个分支作为“信箱”：A 在 `duet/a` 推送状态文件；工作流（或 B 引擎）在 `duet/b` 写回评审结果与完成信号。

启动（A 侧）
```bash
git checkout -b duet/a
mkdir -p mailbox
echo "initial plan" > mailbox/a_to_b.txt
git add mailbox/a_to_b.txt
git commit -m "duet: A → B 初始信息"
git push -u origin duet/a
```

发生了什么
- 工作流 `.github/workflows/duet-git-mailbox.yml` 会在 push 到 `duet/a` 时触发
- 它会在 `duet/b` 分支写入：
  - `mailbox/b_to_a.txt`：评审留言
  - `mailbox/done_by_b.flag`：完成信号

备注
- 如需“真实的 B 引擎”，可以将该工作流替换为你的测试/Lint/AI CLI 评审逻辑
- 不用 Git 的文件信箱，请参见 `samples/collab/file-mailbox`

