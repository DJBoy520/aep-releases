#!/usr/bin/env bash
# promote.sh —— AEP 本地权威可执行切换器（发布工程工具，随 aep-releases 版本化）
#
# 架构约定（2026-10-07 定）：
#   暂存区   ~/WorkSpaces/AEP/aep-releases/bin/   构建产物暂存 + npm 启动器契约。
#                 bin/aep、bin/aep-linux-x64 等无版本名属于 index.js / install-binary.js /
#                 pack-plugin.sh 的固定查找契约，禁止改名或替换为 symlink。
#   运行时   ~/WorkSpaces/AEP/bin/                唯一权威执行点：永远只保留当前一个版本
#                 （aep-<版本> 实体文件 + 唯一 aep symlink）。旧版本不上本机，归档在
#                 GitHub Release（aep-releases）；回滚 = 取回旧版产物后 promote.sh <版本> <产物>。
#   PATH     各 shell rc 挂 $HOME/WorkSpaces/AEP/bin；~/.local/bin 等全局目录不落任何 AEP 文件。
#
# 用法：
#   promote.sh <版本> [产物路径]   完整晋升：校验自版本 → 复制为 aep-<版本> → 原子切 symlink
#                                  → 自检 → 自动清理运行时其他历史版本（只留最新）
#   promote.sh --switch <版本>     仅切 symlink（需该版本文件仍在运行时；常态只留最新版，
#                                  回滚请取回旧版产物后走完整晋升）
#   promote.sh --list              列出运行时全部版本与当前指向
set -euo pipefail

RUNTIME_DIR="${AEP_RUNTIME_DIR:-$HOME/WorkSpaces/AEP/bin}"
STAGE_BIN="${AEP_STAGE_BIN:-$HOME/WorkSpaces/AEP/aep-releases/bin}"

die() { echo "promote.sh: $*" >&2; exit 1; }

bin_version() { "$1" --version 2>/dev/null | head -n1; }
sha256_of() { sha256sum "$1" | cut -d' ' -f1; }

switch_link() {
  local version="$1"
  [ -x "$RUNTIME_DIR/aep-$version" ] || die "运行时不存在可执行的 aep-$version（先 promote 或检查版本号）"
  ln -sfn "aep-$version" "$RUNTIME_DIR/.aep.new.$$"
  mv -T "$RUNTIME_DIR/.aep.new.$$" "$RUNTIME_DIR/aep"
}

cmd_list() {
  [ -d "$RUNTIME_DIR" ] || die "运行时目录不存在: $RUNTIME_DIR"
  echo "运行时目录: $RUNTIME_DIR"
  local cur
  cur="$(readlink "$RUNTIME_DIR/aep" 2>/dev/null || true)"
  echo "当前 aep -> ${cur:-（无 symlink）}"
  local f
  for f in "$RUNTIME_DIR"/aep-*; do
    [ -e "$f" ] || continue
    local marker=""
    [ "${f##*/}" = "$cur" ] && marker="   <= 当前"
    printf '  %-20s %s%s\n' "${f##*/}" "$(bin_version "$f")" "$marker"
  done
}

cmd_promote() {
  local version="$1"
  local artifact="${2:-$STAGE_BIN/aep-linux-x64}"
  [ -x "$artifact" ] || die "产物不存在或不可执行: $artifact"
  local got
  got="$(bin_version "$artifact")"
  [ "$got" = "$version" ] || die "产物自版本（$got）与目标版本（$version）不符，拒绝晋升。产物: $artifact"
  mkdir -p "$RUNTIME_DIR"
  local dest="$RUNTIME_DIR/aep-$version"
  if [ -e "$dest" ]; then
    [ "$(sha256_of "$dest")" = "$(sha256_of "$artifact")" ] \
      || die "$dest 已存在但与产物不一致（历史版本禁止覆盖）。换版本名或手工处理。"
    echo "== aep-$version 已存在且与产物逐字节一致，跳过复制"
  else
    local tmp="$RUNTIME_DIR/.aep-$version.incoming.$$"
    cp "$artifact" "$tmp"
    chmod 755 "$tmp"
    [ "$(bin_version "$tmp")" = "$version" ] || { rm -f "$tmp"; die "复制后自检失败，已清理临时文件"; }
    mv -T "$tmp" "$dest"
  fi
  switch_link "$version"
  # 只留最新版：清掉运行时里其他历史版本（旧版归档在 GitHub Release，不上本机）
  local f
  for f in "$RUNTIME_DIR"/aep-*; do
    [ -e "$f" ] || continue
    [ "${f##*/}" = "aep-$version" ] || rm -f "$f"
  done
  echo "== 晋升完成: $(bin_version "$RUNTIME_DIR/aep")  sha256=$(sha256_of "$dest")（运行时已只保留当前版）"
}

case "${1:-}" in
  --list)
    cmd_list
    ;;
  --switch)
    [ $# -ge 2 ] || die "用法: promote.sh --switch <版本>"
    switch_link "$2"
    echo "== aep -> $(readlink "$RUNTIME_DIR/aep")（$(bin_version "$RUNTIME_DIR/aep")）"
    ;;
  -h|--help|'')
    grep '^#' "$0" | sed 's/^# \{0,1\}//'
    ;;
  *)
    cmd_promote "$@"
    ;;
esac
