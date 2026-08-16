# dotfiles リポジトリの運用ルール

## 管理方式

- 基本は **symlink 管理**: 実体はこのリポジトリ、`install.sh` が `~` 側へリンクを張る。
  リンク先（`~/.zshrc` 等）を編集すればリポジトリに直接反映される
- 例外は **コピー管理**: `claude/settings.json` は Claude Code 自身が書き換えるため
  symlink せず、`sync.sh` が取り込む
- 同期・プッシュは `./sync.sh --push`（zsh では `dotsync` エイリアス）

## 新しい設定ファイルを管理下に追加する手順

1. 実ファイルを用途別ディレクトリへ `cp`（例: `karabiner/karabiner.json`）
2. `install.sh` に `link` 行を 1 行追加
3. `./install.sh` を実行（既存ファイルは自動でバックアップされ symlink になる）
4. README の構成ツリーを更新

## 秘密情報のルール（厳守）

- API キー・トークン類はリポジトリに置かない → `~/.zshrc.local`（管理外）へ
- 実名を含むホームパスは `$HOME` に置換してからコミットする
- 内部 IP・ssh 接続先はリポジトリに置かない → `~/.zshrc.local` へ
- コミット前に必ず staged 差分を秘密情報スキャンする（`sync.sh` に組み込み済み。
  手動コミット時は `sync.sh` 内の grep と同じ正規表現を使う）
- brew で何か入れたら `Brewfile`（共通）か `Brewfile.personal`（自宅のみ）に追記する。
  `./sync.sh` が未記載を警告する
- このリポジトリは **公開リポジトリ**（github.com/Andryu/dotfiles）
