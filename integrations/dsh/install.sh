#!/usr/bin/env bash
# DSH AEP 插件安装：放置覆盖层并提示接线命令
set -e
SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.dsh/aep"
mkdir -p "$DEST"
cp "$SRC/dsh-aep-mcp.patch.yaml" "$DEST/"
echo "已安装覆盖层: $DEST/dsh-aep-mcp.patch.yaml"
echo "接线（二选一）："
echo "  1) 临时:  dsh --profile web --patch $DEST/dsh-aep-mcp.patch.yaml <app-args>"
echo "  2) 持久:  将 --patch 参数写入 dsh 启动脚本/systemd（dsh-workspace/dsh-start-all.sh）"
echo "校准: dsh --profile web --dump-config | grep -A6 mcp"
echo "CLI:  确保 aep 在 PATH（cp aep-linux-x64 ~/.local/bin/aep 或用 tests/nightly 包装器）"
