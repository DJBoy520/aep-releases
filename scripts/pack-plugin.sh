#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$DIR/bin"

echo "=== AEP Plugin Packaging Script ==="
echo "Target: $DIR"

# 检查当前系统对应的核心二进制
if [ "$OS" = "Windows_NT" ] || [ "$(uname -s | grep -i 'mingw\|cygwin\|msys')" ]; then
  if [ ! -f "$BIN_DIR/aep.exe" ]; then
    echo "⚠️ 警告: $BIN_DIR/aep.exe 尚不存在！"
    echo "请先运行 scripts/fetch-private-release.sh 下载发布制品。"
    exit 1
  fi
  echo "✓ 发现 Windows 执行体: $BIN_DIR/aep.exe"
else
  if [ ! -f "$BIN_DIR/aep" ] && [ ! -f "$BIN_DIR/aep-linux-x64" ]; then
    echo "⚠️ 警告: $BIN_DIR/aep 或 $BIN_DIR/aep-linux-x64 尚不存在！"
    echo "请先运行 scripts/fetch-private-release.sh linux 下载发布制品。"
    exit 1
  fi
  if [ -f "$BIN_DIR/aep-linux-x64" ] && [ ! -f "$BIN_DIR/aep" ]; then
    cp "$BIN_DIR/aep-linux-x64" "$BIN_DIR/aep"
    chmod +x "$BIN_DIR/aep"
  fi
  echo "✓ 发现 Linux 执行体: $BIN_DIR/aep"
fi

OUT_TGZ="$DIR/aep-plugin-2.1.7.tgz"
rm -f "$OUT_TGZ"

echo "正在打包制品至: $OUT_TGZ ..."
node /home/dj/.npm-global/lib/node_modules/openclaw/dist/entry.js plugins pack --root "$DIR" --out "$OUT_TGZ"

echo "🎉 打包完成！生成分发包: $OUT_TGZ"
