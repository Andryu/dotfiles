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

# --- Brewfile の乖離チェック（警告のみ。判断は人間がする）---
# brew で入れたが Brewfile / Brewfile.personal のどちらにも書かれていないものを出す。
# 出たら Brewfile（共通）か Brewfile.personal（自宅のみ）に追記するか、brew uninstall する。
if command -v brew >/dev/null; then
  declared="$(grep -hoE '^(brew|cask|tap) "[^"]+"' Brewfile Brewfile.personal 2>/dev/null \
    | sed -E 's/^[a-z]+ "([^"]+)"/\1/' | sort -u)"
  installed="$( { brew leaves; brew list --cask; } 2>/dev/null | sort -u)"
  untracked="$(comm -23 <(echo "$installed") <(echo "$declared"))"
  if [ -n "$untracked" ]; then
    echo "WARN: Brewfile 未記載のパッケージ（Brewfile か Brewfile.personal に追記を検討）:"
    echo "$untracked" | sed 's/^/  - /'
    echo ""
  fi
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
# api_key / secret / token は「直後に = や : で値が続く」形だけ検出する。
# 単語単体だと Claude Code が settings.json に書く説明文（"Secrets management: None"）に誤検知する
git add -A
if git diff --cached | grep -v 'grep -iE' | grep -iE "api[_-]?key[a-z_]*\s*[\"']?\s*[:=]|secret[a-z_]*\s*[\"']?\s*[:=]|token[a-z_]*\s*[\"']?\s*[:=]|AIza|BEGIN.*PRIVATE|192\.168\.|$(whoami)"; then
  echo "NG: 秘密情報らしき文字列を検出したためコミットを中止した（上記の行を確認）" >&2
  git reset -q
  exit 1
fi

git commit -m "設定を同期 ($(date +%Y-%m-%d))"
git push
echo "push 完了: $(git log -1 --format=%h)"
