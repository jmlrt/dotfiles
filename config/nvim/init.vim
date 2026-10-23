set background=dark
set cursorline
set colorcolumn=80
set tabstop=2 expandtab " set tab to 2 spaces
set shiftwidth=2 " set indent to 2 spaces
set autoread " auto reload files

" bash like file completion
set wildmode=longest,list,full
set wildmenu

" folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" python
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=119 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix|

" disable mouse interactions
set mouse=

" <leader>w / <leader>n instead of <S-w>/<S-x>, which shadow real motions
nnoremap <leader>w :set wrap!<CR>
nnoremap <leader>n :set number!<CR>
