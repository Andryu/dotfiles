" Coding
" javascript
autocmd FileType javascript :compiler gjslint
autocmd FileType javascript setl ts=2
autocmd QuickfixCmdPost make copen

call neobundle#begin(expand('~/.vim/bundle'))
" Ruby
" Ruby-end
NeoBundle 'tpope/vim-endwise'
call neobundle#end()

let g:syntastic_mode_map = {
            \ 'mode': 'passive',
            \ 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers  = ['rubocop']
