#!/usr/bin/env bash
# dotfiles installer — 冪等。既存ファイルは ~/.dotfiles_backup/<日時>/ に退避してからリンクする
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "skip (linked): $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
    echo "backup: $dst -> $BACKUP_DIR/"
  fi
  ln -s "$src" "$dst"
  echo "link: $dst -> $src"
}

# --- shell ---
link zsh/zshrc "$HOME/.zshrc"

# --- git ---
link git/gitconfig "$HOME/.gitconfig"
link git/ignore "$HOME/.config/git/ignore"

# --- tmux / vim ---
link tmux/tmux.conf "$HOME/.tmux.conf"
link vim/vimrc "$HOME/.vimrc"

# --- ターミナル環境（ghostty / herdr / cmux）---
link ghostty/config "$HOME/.config/ghostty/config"
link herdr/config.toml "$HOME/.config/herdr/config.toml"
link cmux/cmux.json "$HOME/.config/cmux/cmux.json"
link cmux/settings.json "$HOME/.config/cmux/settings.json"

# --- Claude Code ---
link claude/CLAUDE.md "$HOME/.claude/CLAUDE.md"
# settings.json は Claude Code 自身が書き換える（プラグイン有効化等）ため symlink しない。
# 初回セットアップ時のみコピーし、以降の同期は手動（README 参照）
if [ ! -f "$HOME/.claude/settings.json" ]; then
  mkdir -p "$HOME/.claude"
  cp "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"
  echo "copy: ~/.claude/settings.json"
fi

# --- 秘密情報テンプレート（リポジトリ管理外）---
if [ ! -f "$HOME/.zshrc.local" ]; then
  cp "$DOTFILES/zsh/zshrc.local.example" "$HOME/.zshrc.local"
  echo "copy: ~/.zshrc.local （API キー等はこのファイルに書く）"
fi

echo ""
echo "done. ツール一式を入れるには: brew bundle --file \"$DOTFILES/Brewfile\""
