# dotfiles

AI エージェント開発を中心とした macOS 開発環境の設定。
シンボリックリンク方式で `install.sh` から冪等に適用する。

（旧構成: NeoBundle 時代の Vim 中心構成 → `dotfiles-dein` → 本構成に刷新）

## 構成

```
dotfiles/
├── install.sh        # シンボリックリンクを張る（既存は ~/.dotfiles_backup/ に退避）
├── sync.sh           # コピー管理ファイル取り込み＋秘密情報スキャン＋commit/push（alias: dotsync）
├── CLAUDE.md         # このリポジトリの運用ルール（ファイル追加手順・秘密情報ルール）
├── Brewfile          # brew bundle 用のツール一覧
├── zsh/              # ~/.zshrc（履歴・補完・プロンプト・AI エージェント用エイリアス）
├── git/              # ~/.gitconfig と ~/.config/git/ignore
├── tmux/             # ~/.tmux.conf（tmux 3.x。SSH 先・保険用）
├── vim/              # ~/.vimrc（プラグインなし最小構成）
├── ghostty/          # ~/.config/ghostty/config（herdr 連携キーバインド込み）
├── herdr/            # ~/.config/herdr/config.toml（cmux 互換キーバインド）
├── cmux/             # ~/.config/cmux/{cmux.json,settings.json}
└── claude/           # ~/.claude/CLAUDE.md（グローバル指示）と settings.json（参照コピー）
```

## セットアップ

```sh
git clone <this repo> ~/Workspace/dotfiles
cd ~/Workspace/dotfiles
./install.sh
brew bundle --file Brewfile
```

Brewfile 管理外のツール（uv / claude / ollama）の導入コマンドは Brewfile 末尾のコメント参照。

## 秘密情報の扱い

API キーなどの秘密情報は **リポジトリに置かない**。`~/.zshrc.local` に書く
（`install.sh` が初回に `zsh/zshrc.local.example` からテンプレートをコピーする）。
マシン固有の git 設定は `~/.gitconfig.local` に書く。

## Claude Code の settings.json について

`~/.claude/settings.json` は Claude Code 自身が書き換える（プラグイン有効化など）ため
symlink せず、`sync.sh` が取り込む（実名入りホームパスは `$HOME` に自動置換される）。

## 日常の同期フロー

symlink 管理のファイルは `~` 側を編集すればそのままリポジトリに反映されるので、
あとは `dotsync`（= `./sync.sh --push`）を打つだけでよい:

1. コピー管理ファイル（`~/.claude/settings.json`）をサニタイズして取り込み
2. staged 差分を秘密情報スキャン（検出したら中止）
3. コミットして push

新しい設定ファイルを管理下に追加する手順は `CLAUDE.md` 参照。

hooks が参照するスクリプト（`~/.claude/hooks/*.sh`）や statusline は
agent-crew 側で管理しているため、このリポジトリには含めない。

## ターミナル環境のメモ

- **cmux / herdr / Ghostty** は 3 点でキーバインドを整合させている。
  herdr のテーマ（tokyo-night）と Ghostty のテーマ（TokyoNight Night）は揃えること。
  詳細は各設定ファイル内のコメント参照。
- tmux は SSH 先などでの利用が主。ローカルのエージェント並列運用は cmux / herdr。
