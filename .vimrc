syntax on

nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

inoremap kj <ESC>`^
cnoremap kj <C-c>
xnoremap kj <ESC>
onoremap kj <ESC>

inoremap jk <ESC>`^
cnoremap jk <C-c>
xnoremap jk <ESC>
onoremap jk <ESC>

nnoremap <Space> :noh<CR>

nnoremap p p=`]g;
nnoremap P P=`]g;

set timeoutlen=50 ttimeoutlen=0

set ffs=unix,dos,mac
set fencs=utf-8,cp1251,koi8-r,ucs-2,cp866

set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent
set cindent

set showmatch
set hlsearch
set incsearch
set ignorecase

set showtabline=1
