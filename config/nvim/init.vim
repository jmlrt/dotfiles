set nocompatible " disable legacy compatible
set background=dark
set cursorline
set wrap
set nonumber
set tabstop=2 expandtab " set tab to 2 spaces
set shiftwidth=2 " set indent to 2 spaces
syntax enable " enable syntax highlighting
set autoread " auto reload files
set termguicolors " true colors
set encoding=utf-8
set colorcolumn=80

" vim-plug
call plug#begin('~/.config/nvim/plugged')
    Plug 'junegunn/fzf.vim'
call plug#end()

" fzf
execute 'set rtp+=' . $HOMEBREW_PREFIX . '/opt/fzf'
nnoremap <C-P> :Files<CR>
nnoremap <C-R> :Rg<CR>

" bash like file completion
set wildmode=longest,list,full
set wildmenu

" filetype detection
if has("autocmd")
  filetype indent plugin on
endif

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
