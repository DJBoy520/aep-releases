# Hermes AEP 插件
`install.sh` 向 `~/.hermes/config.yaml` 的 mcp_servers 合并全功能 `aep` 条目
（node + aep-refimpl packages/mcp-server，issuer 全 21 工具；自动备份 config.yaml）。
既有 `aep-audit`/`aep-verify`（verifier 模式）保留不动。
CLI 侧：`aep` 在 PATH 即可（安装见 aep-releases 根目录 RELEASE-CHECKLIST）。

> 源头：本目录 SKILL.md 与 aep-refimpl/skills/aep-session-evidence 同源；修改一律在 integrations/ 进行后全量同步。
