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
├── Brewfile          # brew bundle 用のツール一覧（自宅・仕事 共通）
├── Brewfile.personal # 自宅マシンだけに入れるもの（Discord 等）
├── zsh/              # ~/.zshrc（履歴・補完・プロンプト・AI エージェント用エイリアス）
├── git/              # ~/.gitconfig と ~/.config/git/ignore
├── tmux/             # ~/.tmux.conf（tmux 3.x。SSH 先・保険用）
├── vim/              # ~/.vimrc（プラグインなし最小構成）
├── ghostty/          # ~/.config/ghostty/config（herdr 連携キーバインド込み）
├── herdr/            # ~/.config/herdr/config.toml（cmux 互換キーバインド）
├── cmux/             # ~/.config/cmux/{cmux.json,settings.json}
└── claude/           # ~/.claude/CLAUDE.md（グローバル指示）と settings.json（参照コピー）
```

## セットアップ（新しいマシン・仕事マシン）

```sh
# 1. Homebrew（未導入なら）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. clone して symlink を張る
git clone https://github.com/Andryu/dotfiles.git ~/Workspace/dotfiles
cd ~/Workspace/dotfiles
./install.sh

# 3. ツール一式（共通）。自宅なら Brewfile.personal も
brew bundle --file Brewfile
# brew bundle --file Brewfile.personal

# 4. Brewfile 管理外（導入コマンドは Brewfile 末尾のコメント参照）
#    uv / claude / ollama

# 5. マシン固有の設定（リポジトリ管理外）
$EDITOR ~/.zshrc.local      # API キー・内部 IP・仕事用エイリアス
$EDITOR ~/.gitconfig.local  # 仕事用のメールアドレス等（[user] セクション）

# 6. herdr × Claude Code 連携（claude 導入後）
herdr integration install claude          # ~/.claude/hooks/herdr-agent-state.sh を置き
                                          # settings.json に SessionStart hook を追加。
                                          # Claude のセッション ID を herdr に通知し、
                                          # herdr 再起動時のネイティブ復帰
                                          # （resume_agents_on_restore）を可能にする
npx skills add herdrdev/herdr --skill herdr -g   # herdr スキル（Claude から herdr の
                                          # ペイン/タブ/他エージェントを CLI 操作）
herdr integration status                  # claude: current になっていれば OK
```

再起動後の確認: Ghostty を開き herdr を起動 → `Cmd+D` で分割できれば
Ghostty → herdr のキー転送（CSI-u）が効いている。文字が滲む・罫線が崩れる場合は
`brew list --cask font-plemol-jp` でフォントが入っているか確認する。

Brewfile の乖離は `./sync.sh` 実行時に「Brewfile 未記載」として警告される
（brew で新しく入れたら Brewfile / Brewfile.personal のどちらかに追記する）。

### 仕事マシンで置き換えるもの

| 項目 | 場所 | 備考 |
|---|---|---|
| git のメール・署名 | `~/.gitconfig.local` | `git/gitconfig` から include される |
| API キー・社内ホスト | `~/.zshrc.local` | リポジトリには絶対に置かない |
| cmux のワークスペース色分け | `cmux/cmux.json` の `workspaceGroups.byCwd` | 仕事のリポジトリパスに合わせて追記 |
| herdr の worktree 置き場 | `herdr/config.toml` の `[worktrees] directory` | `~/Workspace/.worktrees` 前提 |
| Claude Code の hooks | `claude/settings.json` | agent-crew / Obsidian のパスを参照している。無いものは効かないだけなので害はない |

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
agent-crew 側で管理しているため、このリポジトリには含めない
（`herdr-agent-state.sh` だけは `herdr integration install claude` が生成・更新する）。

## ターミナル環境のメモ

- **cmux / herdr / Ghostty** は 3 点でキーバインドを整合させている。
  herdr のテーマ（tokyo-night）と Ghostty のテーマ（TokyoNight Night）は揃えること。
  詳細は各設定ファイル内のコメント参照。
- Ghostty → herdr のキー転送は CSI-u（kitty keyboard protocol）。ESC+制御バイト方式は
  Ctrl+D が素通りしてシェルが落ちる事故があったので使わない。
- フォントは合成済みの **PlemolJP Console** を 1 つだけ指定する（2 フォント並記は罫線が崩れる）。
  font-size は半角送り幅が整数 px に乗る 17 / 19 を選ぶ（根拠は `ghostty/config` のコメント）。
- tmux は SSH 先などでの利用が主。ローカルのエージェント並列運用は cmux / herdr。
