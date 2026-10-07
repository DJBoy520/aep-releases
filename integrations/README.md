# AEP 智能体插件统一分发目录（唯一权威源）

> 所有 AI 助手（ZCode / Hermes / OpenCode / DSH / OpenClaw / Claude Desktop / Cursor）的
> AEP 插件与技能统一保存在本目录，**统一版本、统一分发**。版本号始终跟随 AEP client
>（`../package.json` 的 version，当前 2.2.1）。任何技能/插件的修改必须在本目录进行，
> 其他位置的副本（如 aep-refimpl/plugins 的本地 dev 市场）一律视为构建产物。

## 目录
- `zcode/`         ZCode 插件源（.zcode-plugin + skills + 自包含 MCP bundle）+ 本地 dev 市场
- `hermes/`        install.sh（config.yaml mcp_servers 合并）+ 会话存证技能
- `opencode/`      install.sh（opencode.jsonc mcp 合并）+ 会话存证技能
- `dsh/`           --patch 覆盖层模板 + install.sh + 会话存证技能
- `claude-desktop/`, `cursor/`  MCP 配置清单（历史既有）
- `openclaw/`      OpenClaw 插件清单（仓库根 openclaw.plugin.json 的说明与指向）

## 版本规则
- `zcode/.zcode-plugin/plugin.json` 的 version == AEP client 版本（同步升）。
- 各家 `SKILL.md`（aep-session-evidence）为同一份内容的分发副本，源头修改后全量同步。
- 技能的 ClawHub 发布（`aep-session-evidence`）与本目录同步更新。

## 安装
各子目录 README.md / install.sh。总入口见仓库根 README.md。
