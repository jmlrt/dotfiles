" VIM Configuration - Vincent Jousse
" Annule la compatibilite avec l'ancetre Vi : totalement indispensable
set nocompatible

" Activation de pathogen
call pathogen#infect()

" -- Affichage
set title		" Met a jour le titre de votre fenetre ou de
			" votre terminal
set number		" Affiche le numero des lignes
set ruler		" Affiche la position actuelle du curseur
set wrap		" Affiche les lignes trop longues sur plusieurs
			" lignes
set scrolloff=3		" Affiche un minimum de 3 lignes autour du curseur
			" (pour le scroll)

" -- Recherche
set ignorecase		" Ignore la casse lors d'une recherche
set smartcase		" Si une recherche contient une majuscule,
			" re-active la sensibilite a la casse
set incsearch		" Surligne les resultats de recherche pendant la
			" saisie
set hlsearch		" Surligne les resultats de recherche

" -- Beep
set visualbell		" Empeche Vim de beeper
set noerrorbells	" Empeche Vim de beeper

" Active le comportement 'habituel' de la touche retour en arriere
set backspace=indent,eol,start

" Cache les fichiers lors de l'ouverture d'autres fichiers
set hidden

" Active la coloration syntaxique
syntax enable

" Active les comportements specifiques aux types de fichiers comme 
" la syntaxe et l'indentation
filetype on
filetype plugin on
filetype indent on

" Utilise la version sombre de Solarized
set background=dark
colorscheme solarized

" Desactiver les touches directionnelles
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Les ; sont rarement utilises l'un a la suite de l'autre
:imap ;; <Esc>
:map ;; <Esc>

let mapleader = ","

" Parametres par defaut pour ack
let g:ackprg="ack -H --nocolor --nogroup --column"
" Place un marqueur et cherche
nmap <leader>j mA:Ack<space>
" Place un marqueur et cherche le mot sous le curseur 
nmap <leader>ja mA:Ack "<C-r>=expand("<cword>")<cr>"
nmap <leader>jA mA:Ack "<C-r>=expand("<cWORD>")<cr>"

let g:ctrlp_map = '<leader>c'

let g:neocomplcache_enable_at_startup = 1

:inoremap { {<CR>}<Up><End>
:inoremap [ []<Left>
:inoremap ( ()<Left> 
