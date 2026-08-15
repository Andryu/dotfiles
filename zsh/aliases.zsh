# エイリアス集

# --- Git ---
alias gs="git status"
alias gb="git branch"
alias gba="git branch -a"
alias gf="git fetch"
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gp="git push"
alias gl="git log --oneline --graph --decorate -20"

# --- ファイル操作 ---
# GNU ls + solarized dircolors（coreutils 導入済みなら色付き gls を使う）
if command -v gls >/dev/null; then
  [ -f "$HOME/.dircolors-solarized" ] && command -v gdircolors >/dev/null && eval "$(gdircolors "$HOME/.dircolors-solarized")"
  alias ls='gls --color=auto'
  alias ll='gls -la --color=auto'
  alias la='gls -a --color=auto'
else
  alias ll="ls -laG"
  alias la="ls -aG"
fi
command -v bat >/dev/null && alias cat="bat --paging=never"

# --- dotfiles ---
alias dot='cd $DOTFILES'
alias zr='source ~/.zshrc'
alias dotsync='$DOTFILES/sync.sh --push'   # 設定の取り込み→スキャン→コミット→push
