set nocompatible " disable legacy compatible
set background=dark
set cursorline
set nowrap " don't wrap lines
set number " print line numbers
set tabstop=2 expandtab " set tab to 2 spaces
set shiftwidth=2 " set indent to 2 spaces
syntax enable " enable syntax highlighting
set autoread " auto reload files
set termguicolors " true colors
set encoding=utf-8
set colorcolumn=80

" vim-plug
call plug#begin('~/.config/nvim/plugged')
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'preservim/nerdtree'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/goyo.vim'
    Plug 'jceb/vim-orgmode'
    Plug 'vim-airline/vim-airline'
call plug#end()

" nerdtree
let NERDTreeShowHidden=1
map <silent> <C-n> :NERDTreeToggle %<CR> " % to open NERDTree in the current directory

" fzf
nnoremap <C-P> :Files<CR>
nnoremap <C-R> :Rg<CR>

" bash like file completion
set wildmode=longest,list,full
set wildmenu

" filetype detection
if has("autocmd")
  filetype indent plugin on
endif

" fzf
set rtp+=/usr/local/opt/fzf

" folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" python
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix|

" disable mouse interactions "
"set mouse=nicr
"map <ScrollWheelUp> <nop>
"map <S-ScrollWheelUp> <nop>
"map <C-ScrollWheelUp> <nop>
"map <ScrollWheelDown> <nop>
"map <S-ScrollWheelDown> <nop>
"map <C-ScrollWheelDown> <nop>
"map <ScrollWheelLeft> <nop>
"map <S-ScrollWheelLeft> <nop>
"map <C-ScrollWheelLeft> <nop>
"map <ScrollWheelRight> <nop>
"map <S-ScrollWheelRight> <nop>
"map <C-ScrollWheelRight> <nop>
set mouse-=a "https://gist.github.com/u0d7i/01f78999feff1e2a8361

map <S-w> :set wrap!<CR>
map <S-x> :set number!<CR>

" treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- List of parsers to ignore installing
  ignore_install = {},
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- list of language that will be disabled
    disable = {},
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
require'lspconfig'.pyright.setup{}
EOF
