# 開発・AI エージェント環境のツール一式（自宅・仕事 共通）
#   適用:            brew bundle --file ~/Workspace/dotfiles/Brewfile
#   個人用も入れる:  brew bundle --file ~/Workspace/dotfiles/Brewfile.personal
#   未記載チェック:  ./sync.sh が「Brewfile 未記載」として警告する
#
# 仕事マシンに入れないもの（Discord 等）は Brewfile.personal に分けている。

tap "manaflow-ai/cmux"

# --- コア CLI ---
brew "coreutils"          # gls / gdircolors（aliases.zsh が使う）
brew "gh"
brew "tmux"
brew "wget"
brew "jq"
brew "ripgrep"
brew "fzf"                # zshrc で `fzf --zsh` を読み込む
brew "fd"
brew "bat"                # aliases.zsh で cat を置換
brew "tree"
brew "glow"               # Markdown をターミナルで読む
brew "util-linux"         # flock（macOS 標準にない。スクリプト排他用）

# --- ランタイム ---
brew "node"
brew "pyenv"
# pyenv で Python をビルドするための依存
brew "openssl@3"
brew "readline"
brew "sqlite"
brew "xz"
brew "zlib"

# --- コンテナ ---
brew "colima"
brew "docker"
brew "docker-compose"

# --- AI エージェント開発（ターミナル環境）---
brew "herdr"              # エージェントマルチプレクサ（~/.config/herdr/config.toml）
cask "cmux"               # AI エージェント向けターミナル（~/.config/cmux/）
cask "ghostty"            # ~/.config/ghostty/config

# --- フォント ---
# Ghostty の font-family = "PlemolJP Console" が前提。ghostty/config のコメント参照。
cask "font-plemol-jp"
# 比較検証した候補（採用せず）: font-hackgen / font-udev-gothic / font-cica / font-ricty-diminished

# --- GUI アプリ ---
cask "visual-studio-code"
cask "google-chrome"
cask "obsidian"
cask "slack"
cask "zoom"

# --- VS Code 拡張 ---
vscode "anthropic.claude-code"

# Brewfile 管理外のツール（導入コマンド）:
#   uv     : curl -LsSf https://astral.sh/uv/install.sh | sh
#   claude : curl -fsSL https://claude.ai/install.sh | bash   （~/.local/bin/claude）
#   ollama : https://ollama.com からアプリを導入（claude-local / claude-fast が利用）
