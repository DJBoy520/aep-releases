# DSH AEP 插件
DSH 为 profile+patch 分层的 Harness。本包交付 `dsh-aep-mcp.patch.yaml` 覆盖层
（mcp_servers.aep → aep-refimpl packages/mcp-server）与 install.sh。
覆盖键名请以 `dsh --profile web --dump-config` 校准（若内层应用键名不同，
改覆盖层键名即可，服务器命令不变）。

> 源头：本目录 SKILL.md 与 aep-refimpl/skills/aep-session-evidence 同源；修改一律在 integrations/ 进行后全量同步。
