#!/usr/bin/env bash
# 設定の同期スクリプト
#   ./sync.sh          # コピー管理ファイルを取り込み、差分を表示
#   ./sync.sh --push   # 秘密情報スキャン後にコミットして push
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

# --- コピー管理ファイルの取り込み（symlink できないもの）---
# Claude Code settings.json: 実名入りホームパスを $HOME に置換して取り込む
if [ -f "$HOME/.claude/settings.json" ]; then
  sed "s|$HOME|\$HOME|g" "$HOME/.claude/settings.json" > claude/settings.json
fi

# --- 差分表示 ---
if [ -z "$(git status --porcelain)" ]; then
  echo "差分なし。同期済み"
  exit 0
fi
git status --short
echo ""
git diff --stat

if [ "${1:-}" != "--push" ]; then
  echo ""
  echo "コミットして push するには: ./sync.sh --push"
  exit 0
fi

# --- 秘密情報スキャン（実名はスクリプトに書かず実行時に導出する）---
git add -A
if git diff --cached | grep -iE "api_key|secret|AIza|BEGIN.*PRIVATE|192\.168\.|$(whoami)"; then
  echo "NG: 秘密情報らしき文字列を検出したためコミットを中止した（上記の行を確認）" >&2
  git reset -q
  exit 1
fi

git commit -m "設定を同期 ($(date +%Y-%m-%d))"
git push
echo "push 完了: $(git log -1 --format=%h)"
