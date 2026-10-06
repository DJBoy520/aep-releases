#!/usr/bin/env bash
# OpenCode AEP 插件安装：向 ~/.config/opencode/opencode.jsonc 合并 aep mcp（自动备份）
set -e
cp ~/.config/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc.bak-aep-$(date +%Y%m%d)
python3 - <<'PY'
p='/home/dj/.config/opencode/opencode.jsonc'
s=open(p).read()
if '"aep"' in s.split('"mcp"')[-1][:400]:
    print('aep 已存在，跳过'); raise SystemExit
entry='''  "mcp": {
    "aep": {
      "type": "local",
      "command": ["node", "/home/dj/WorkSpaces/openclaw/aep-refimpl/packages/mcp-server/dist/index.js"],
      "environment": {},
      "enabled": true
    },'''
s=s.replace('"mcp": {', entry, 1)
open(p,'w').write(s)
print('opencode mcp merged')
PY
opencode --version
