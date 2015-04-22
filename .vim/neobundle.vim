"------------------------------------------------------------
"NeoBundle
"------------------------------------------------------------
set nocompatible
filetype off
if has('vim_starting')
  "neobundleの設置場所
  set runtimepath+=~/.vim/bundle/neobundle.vim
  "pluginの設置場所
  "  call neobundle#rc(expand('~/.vim/bundle'))
  call neobundle#begin(expand('~/.vim/bundle'))

  if neobundle#has_fresh_cache(expand('~/.vimrc'))
      NeoBundleLoadCache  " キャッシュの読込み
  else

    NeoBundleFetch 'Shougo/neobundle.vim'
    if neobundle#exists_not_installed_bundles()
        echomsg 'Not installed bundles : ' .
                \ string(neobundle#get_not_installed_bundle_names())
        echomsg 'Please execute ":NeoBundleInstall" command.' "finish
    endif

    " Basic
    " vim-dispatch
    NeoBundle 'tpope/vim-dispatch.git'
    " Log Color
    NeoBundle 'vim-scripts/AnsiEsc.vim'
    " Quick run
    NeoBundle "https://github.com/thinca/vim-quickrun.git"
    " Git
    NeoBundle 'https://github.com/tpope/vim-fugitive.git'
    NeoBundle 'https://github.com/gregsexton/gitv.git'
    " Neocomplcache
    NeoBundle "Shougo/neosnippet"
    NeoBundle "Shougo/neosnippet-snippets"
    " Neosnippet 補完
    NeoBundle 'Shougo/neocomplcache'
    "NERDTreeToggle
    NeoBundle 'https://github.com/scrooloose/nerdtree.git'


    " Status Line
    " vim-airline
    NeoBundle 'bling/vim-airline'
    "file manager unit-vim
    NeoBundle "https://github.com/Shougo/unite.vim.git"
    " Unit.vimで最近使ったファイルを表示できるようにする
    NeoBundle "Shougo/neomru.vim"


    " Coding
    " HTML
    NeoBundle 'mattn/emmet-vim'
    " check program syntax
    NeoBundle 'https://github.com/scrooloose/syntastic.git'
    " javascript
    NeoBundle 'JavaScript-syntax'
    NeoBundle 'pangloss/vim-javascript'
    "Installation check.
  endif

    call neobundle#end()
    NeoBundleSaveCache  " キャッシュの書込み
    filetype plugin indent on
endif


