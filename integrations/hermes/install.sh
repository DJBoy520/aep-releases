#!/usr/bin/env bash
# Hermes AEP 插件安装：向 ~/.hermes/config.yaml mcp_servers 合并全功能 aep 条目（自动备份）
set -e
python3 - <<'PY'
import yaml
p='/home/dj/.hermes/config.yaml'
import os; os.system(f'cp {p} {p}.bak-aep-$(date +%Y%m%d)')
d=yaml.safe_load(open(p))
ms=d.setdefault('mcp_servers',{})
ms['aep']={'command':'node','args':['/home/dj/WorkSpaces/AEP/aep-refimpl/packages/mcp-server/dist/index.js'],'enabled':True}
open(p,'w').write(yaml.safe_dump(d,sort_keys=False,allow_unicode=True))
print('hermes mcp_servers:', list(ms.keys()))
PY
echo "CLI: 确保 aep 在 PATH（见 aep-releases RELEASE-CHECKLIST）"
