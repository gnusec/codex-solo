# nlscan - newLISP 并发端口扫描器

一个使用 newLISP 实现的并发 TCP 端口扫描器，默认使用 `nc -z -w` 完成可靠的连接超时控制，支持从命令行或配置文件提供参数，并可生成可直接用于 nmap 的命令与目标列表。

## 用法

运行：

- 直接执行脚本（需要 newLISP 已安装）：
  - `newlisp tools/nlscan.lsp --targets 127.0.0.1 --ports 22,80,443 --concurrency 200 --timeout 1`

常用参数：

- `-t, --targets`：目标，支持逗号分隔、`@file`（每行一个）、IPv4 CIDR（如 `192.168.1.0/24`）。
- `-P, --ports`：端口列表，支持逗号和区间（如 `22,80,443,8000-8100`）。注意：为避免与 newlisp 自身的 `-p` 选项冲突，请使用 `-P` 或 `--ports`。
- `-c, --concurrency`：并发 worker 数量，默认 200。
- `-T, --timeout`：每端口连接超时（秒），默认 1。
- `-f, --format`：输出格式：`text|json|ndjson`，默认 `text`。
- `-o, --output`：输出文件路径，不指定时打印到 stdout。
- `-C, --config`：INI 风格配置文件（key=value）。命令行会覆盖配置文件中的同名项。
- `--method`：`nc`（默认）或 `net`（newLISP 的 `net-connect`，不推荐）。
- `--emit-nmap-cmds PATH`：输出每个目标的 nmap 命令至 `PATH`。
- `--emit-nmap-iL PATH`：输出含开放端口的目标列表至 `PATH`（适配 `nmap -iL`）。

示例：

```
newlisp tools/nlscan.lsp -t @targets.txt -P 22,80,443,8000-8100 -c 300 -T 1 -f json -o out.json \
  --emit-nmap-cmds nmap_cmds.sh --emit-nmap-iL nmap_hosts.txt
```

配置文件（INI）：

```
# config.ini
targets=@targets.txt
ports=22,80,443,8000-8005
concurrency=200
timeout=1
format=json
output=out.json
emit_nmap_cmds=nmap_cmds.sh
emit_nmap_iL=nmap_hosts.txt
```

使用配置：

```
newlisp tools/nlscan.lsp -C config.ini
```

## nmap 衔接
- `--emit-nmap-cmds cmds.sh`：生成每个有开放端口的主机一条命令：`nmap -Pn -n -sV -p <ports> <host>`。
- `--emit-nmap-iL hosts.txt`：生成仅含发现有开放端口的主机列表，可配合 `nmap -iL hosts.txt` 使用。

## 开发与测试

- 任务与验收标准见 `docs/TASK.md`。
- 运行测试：

```
bash tests/run.sh
```

所有测试通过后，我们会输出 `[SOLO_DONE]` 以结束项目。
