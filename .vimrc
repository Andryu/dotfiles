set number
"if tab clicked is white space 4
set tabstop=4
set shiftwidth=4
set expandtab
set wildmenu
set cursorline
set title
set hlsearch
" status line
set laststatus=2


nmap <F7> :setfiletype html<Enter>
inoremap <C-d> $
inoremap <C-a> @
inoremap {} {}<LEFT>
inoremap [] []<LEFT>
inoremap () ()<LEFT>
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>
inoremap <> <><LEFT>
"Escの2回押しでハイライト消去
nmap <ESC><ESC> ;nohlsearch<CR><ESC>


";でコマンド入力(; と:入れ替え)
"noremap ; :
"
""全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/

"保存時に行末の空白を除去する
"autocmd BufWritePre * :%s/\s/\+$//ge
"保存時にtabをスペースに変換
"autocmd BufWritePre * :%s/\t/    /ge
"↑の設定だとカーソルが移動するので
function! s:remove_dust()
    let cursor = getpos(".")
    " 保存時に行末の空白を除去する
    %s/\s\+$//ge
    " 保存時にtabを2スペースに変換する
    %s/\t/  /ge
    call setpos(".", cursor)
    unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()

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
  NeoBundleFetch 'Shougo/neobundle.vim'
  call neobundle#end()
  filetype plugin indent on
  "Installation check.
  if neobundle#exists_not_installed_bundles()
      echomsg 'Not installed bundles : ' .
              \ string(neobundle#get_not_installed_bundle_names())
      echomsg 'Please execute ":NeoBundleInstall" command.' "finish
  endif
endif

"file manager
NeoBundle "https://github.com/Shougo/unite.vim.git"
" Unit.vimで最近使ったファイルを表示できるようにする
NeoBundle "Shougo/neomru.vim"

"Code suport
NeoBundle "Shougo/neosnippet"
NeoBundle "Shougo/neosnippet-snippets"
"Color
NeoBundle "https://github.com/altercation/vim-colors-solarized.git"
NeoBundle 'https://github.com/tpope/vim-vividchalk.git'
NeoBundle 'https://github.com/Lokaltog/vim-distinguished.git'
NeoBundle 'https://github.com/nanotech/jellybeans.vim.git'
NeoBundle 'https://github.com/vim-scripts/candy.vim.git'
NeoBundle 'https://github.com/dandorman/vim-colors.git'
" Log Color
NeoBundle 'vim-scripts/AnsiEsc.vim'

"HTML
NeoBundle 'mattn/emmet-vim'

"
NeoBundle "https://github.com/thinca/vim-quickrun.git"
"file Tree
NeoBundle 'https://github.com/scrooloose/nerdtree.git'
"Git
NeoBundle 'https://github.com/tpope/vim-fugitive.git'
NeoBundle 'https://github.com/gregsexton/gitv.git'
" grep検索の実行時に    QuickFix list表示
autocmd QuickFixCmdPost *grep* cwindow
" ステータス行に現在のgitブランチを表示
"set statusline+=%{fugitive#statusline()}

" vim-airline
NeoBundle 'bling/vim-airline'

" check program syntax
NeoBundle 'https://github.com/scrooloose/syntastic.git'
" javascript
NeoBundle 'JavaScript-syntax'
NeoBundle 'pangloss/vim-javascript'
autocmd FileType javascript :compiler gjslint
autocmd FileType javascript setl ts=2
autocmd QuickfixCmdPost make copen
" power line
"NeoBundle 'itchyny/lightline.vim'

" Ruby-end
NeoBundle 'tpope/vim-endwise'


""------------------------------------------------------------
"neocomplcache
"------------------------------------------------------------
NeoBundle 'Shougo/neocomplcache'
let g:neocomplcache_enable_at_startup = 1

let g:neocomplcache_ctags_arguments_list = {
    \ 'perl' : '-R -h ".pm"'
    \ }
" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
  \ 'default'    : '',
  \ 'perl'       : $HOME . '/.vim/dict/perl.dict',
    \ 'javascript' : $HOME . '/.vim/dict/javascript.dict',
    \ 'html'       : $HOME . '/.vim/dict/javascript.dict'
    \ }
" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
     let g:neocomplcache_keyword_patterns = {}
endif
     let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

"------------------------------------------------------------
"neosnippet
"------------------------------------------------------------
"old---------------------
"" Plugin key-mappings.
"imap <C-k>    <Plug>(neosnippet_expand_or_jump)
"smap <C-k>    <Plug>(neosnippet_expand_or_jump)
"" For snippet_complete marker.
"if has('conceal')
"  set conceallevel=2 concealcursor=i
"endif
"" Tell Neosnippet about the other snippets
"let g:neosnippet#snippets_directory='~/.vim/snippets'
"------------------------
" Plugin key-mappings.
imap <C-k>    <Plug>(neosnippet_expand_or_jump)
smap <C-k>    <Plug>(neosnippet_expand_or_jump)
" SuperTab like snippets behavior.
imap  neosnippet#expandable_or_jumpable() ? "\(neosnippet_expand_or_jump)" : pumvisible() ? "\" : "\"
smap  neosnippet#expandable_or_jumpable() ?"\(neosnippet_expand_or_jump)" : "\"

"For snippet_complete marker.
if has('conceal')
     set conceallevel=2 concealcursor=i
endif
"Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/snipmate-snippets/snippets, ~/.vim/mysnippets'
"------------------------------------------------------------
"molokai
"------------------------------------------------------------
set t_Co=256
syntax on
"colorscheme molokai
set background=dark
let g:solarized_termcolors=256
let g:solarized_contrast='high'
colorscheme solarized

"------------------------------------------------------------
"unite.vim
"------------------------------------------------------------
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> ,ub :<C-u>:Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" 新規タブで開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')

" ESCキーを2回押すと終了する(工事中)
"au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
"au FileType unite inoremap <silent> <buffer> <ESC><ESC> q

"------------------------------------------------------------
"vim-fugitive
"------------------------------------------------------------
"set statusline+=%{fugitive#statusline()}

"------------------------------------------------------------
"NERDTreeToggle
"------------------------------------------------------------
nmap <F9> :NERDTreeToggle<Enter>
"let g:NERDTreeShowHidden=1 "隠しファイル表示
"let g:NERDTreeDirArrows=0
let g:NERDTreeWinSize=25
"------------------------------------------------------------
"ColorRoller
"------------------------------------------------------------
let ColorRoller = {}
let ColorRoller.colors = [
      \ 'molokai',
      \ 'vividchalk',
      \ 'distinguished',
      \ 'jellybeans',
      \ 'Mustang',
      \ 'Zenburn',
      \ 'Wombat',
      \ 'Tomorrow',
      \ 'github',
      \ 'grb256',
      \ 'ir_black',
      \ 'railscasts',
      \ 'twilight',
      \ ]

function! ColorRoller.change()
  let color = get(self.colors, 0)
  silent exe "colorscheme " . color
  redraw
  echo self.colors
endfunction

function! ColorRoller.roll()
  let item = remove(self.colors, 0)
  call insert(self.colors, item, len(self.colors))
  call self.change()
endfunction

function! ColorRoller.unroll()
  let item = remove(self.colors, -1)
  call insert(self.colors, item, 0)
  call self.change()
endfunction

nnoremap <silent><S-C>   :<C-u>call ColorRoller.roll()<CR>
nnoremap <silent><S-F9> :<C-u>call ColorRoller.unroll()<CR>

"------------------------------------------------------------
"文字コード
"------------------------------------------------------------
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  unlet s:enc_euc
  unlet s:enc_jis
endif
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" lightline
"let g:lightline = {
"      \ 'colorscheme': 'wombat',
"      \ 'component': {
"      \   'readonly': '%{&readonly?"\u2b64":""}',
"      \ },
"      \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
"      \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
"      \ }

"ruby
"NeoBundle 'scrooloose/syntastic'
let g:syntastic_mode_map = {
            \ 'mode': 'passive',
            \ 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers  = ['rubocop']

" --------------------------------------------
" Highlighting
set cursorline
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=white guibg=white

" Airline {{{1
let g:airline_section_a = airline#section#create(['mode','','branch'])
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#fnamemod = ':t'

set guifont=Ricty\ Regular\ for\ Powerline:h14
let g:Powerline_symbols = 'fancy'
set t_Co=256
let g:airline_theme='badwolf'
let g:airline_left_sep = '⮀'
let g:airline_right_sep = '⮂'
let g:airline_linecolumn_prefix = '⭡'
let g:airline_branch_prefix = '⭠'
let g:airline#extensions#tabline#left_sep = '⮀'
let g:airline#extensions#tabline#left_alt_sep = '⮀'
" /=Airline }}}1

"let g:airline_section_b = '%{strftime("%c")}'
"let g:airline_section_y = 'BN: %{bufnr("%")}'
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif
" /=other }}}1
