# Dotfiles

install vim and setting vimrc

Please install vim-enhanced
ex) yum install vim-enhanced

# Usage

## Vim
cd dotfiles
./set_up

vim

:NeoBundleInstall

## tmux

vim ~/.tmux.conf
source-file ~/dotfiles/.tmux.conf

## bashrc

vim ~/.bashrc
source ~/dotfiles/alias.sh

## Notice
open vim and alert

```
Unfortunately, zencoding-vim was moved to emmet-vim, please use it.
```
mv ~/.vim/bundle/zencoding ~/.vim/bundle/emmet-vim


# History
* ver 1.0.0
  - defaultのsnipettは利用できなくなった
  - 以下を追記
  - NeoBundle "Shougo/neosnippet"
  - NeoBundle "Shougo/neosnippet-snippets"

* ver 1.1.0
  - unite vim設定追加 ,ua,ub,uf -> tabopne C-t
  - Log Color Ansi追加
  - Ruby End追加
  - Ggrep検索追加まだ開発途中

* ver 1.1.1
  - airline追加
  - statuslineを表示

