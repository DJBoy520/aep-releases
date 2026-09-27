#!/usr/bin/env bash
# aep-refimpl 私有 Release 资产同步脚本（安全读取本地 .env 密钥，不泄露至 Git）
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$DIR/bin"
ENV_FILE="$DIR/.env"

# 优先读取本地 .env 密钥
if [ -f "$ENV_FILE" ]; then
  TOKEN_VAL=$(grep -E "^GITHUB_TOKEN=" "$ENV_FILE" | cut -d '=' -f2- | tr -d '"' | tr -d "'")
  if [ -n "$TOKEN_VAL" ]; then
    GITHUB_TOKEN="$TOKEN_VAL"
  fi
fi

if [ -z "$GITHUB_TOKEN" ]; then
  echo "❌ 错误: 未检测到 GITHUB_TOKEN！请在 $ENV_FILE 中配置，或通过环境变量导出。"
  exit 1
fi

REPO="DJBoy520/aep-refimpl"
mkdir -p "$TARGET_DIR"

echo "=== 开始从私有仓库 $REPO 下载发布资产 ==="

# 获取最新 release 的 asset 列表
ASSETS_JSON=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$REPO/releases/latest")

download_asset() {
  local asset_name="$1"
  local output_name="${2:-$asset_name}"
  
  local asset_id=$(echo "$ASSETS_JSON" | jq -r ".assets[] | select(.name==\"$asset_name\") | .id")
  if [ -z "$asset_id" ] || [ "$asset_id" == "null" ]; then
    echo "❌ 未找到资产: $asset_name"
    return 1
  fi

  echo "⬇️ 正在下载: $asset_name (ID: $asset_id) -> $TARGET_DIR/$output_name ..."
  curl -s -L \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/octet-stream" \
    -o "$TARGET_DIR/$output_name" \
    "https://api.github.com/repos/$REPO/releases/assets/$asset_id"
  
  echo "✓ 下载完成: $TARGET_DIR/$output_name ($(du -h "$TARGET_DIR/$output_name" | cut -f1))"
}

# 默认下载 Windows 与 Linux 原生独立执行体
if [ "$1" == "all" ]; then
  download_asset "aep.exe"
  download_asset "aep-windows-x64-setup.exe"
  download_asset "aep-windows-x64.zip"
  download_asset "aep-linux-x64"
  download_asset "aep-linux-x64.tar.gz"
elif [ "$1" == "linux" ]; then
  download_asset "aep-linux-x64"
  chmod +x "$TARGET_DIR/aep-linux-x64"
else
  # 默认下载用于插件随包打包的 aep.exe
  download_asset "aep.exe"
fi

echo "=== 资产同步完成 ==="
