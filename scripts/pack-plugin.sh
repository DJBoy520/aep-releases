#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$DIR/bin"

echo "=== AEP Plugin Packaging Script ==="
echo "Target: $DIR"

if [ ! -f "$BIN_DIR/aep.exe" ]; then
  echo "⚠️ 警告: $BIN_DIR/aep.exe 尚不存在！"
  echo "请先将编译好的 aep.exe 复制到 distribution/bin/ 目录下。"
  exit 1
fi

echo "✓ 发现 Windows 核心执行体: $BIN_DIR/aep.exe"

# 使用 openclaw plugins pack 生成标准分发制品
OUT_TGZ="$DIR/aep-plugin-1.0.0.tgz"
rm -f "$OUT_TGZ"

echo "正在打包制品至: $OUT_TGZ ..."
node /home/dj/.npm-global/lib/node_modules/openclaw/dist/entry.js plugins pack --root "$DIR" --out "$OUT_TGZ"

echo "🎉 打包完成！生成分发包: $OUT_TGZ"
