"------------------------------------
"General settings:
"------------------------------------

nnoremap h <BS>
nnoremap l <Space>
xnoremap h <BS>
xnoremap l <Space>

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

inoremap KJ <ESC>`^
cnoremap KJ <C-c>
xnoremap KJ <ESC>
onoremap KJ <ESC>

inoremap JK <ESC>`^
cnoremap JK <C-c>
xnoremap JK <ESC>
onoremap JK <ESC>

nnoremap <Space> :noh<CR>

"nnoremap p p=`]g;
"nnoremap P P=`]g;

set timeoutlen=100 ttimeoutlen=0

set showmatch
set hlsearch
set incsearch
"set ignorecase

"------------------------------------
"Vim specific settings:
"------------------------------------

"language
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

syntax on
set showtabline=2
"set mouse=a

set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent
set cindent

set ffs=unix,dos,mac
set fencs=utf-8,cp1251,koi8-r,ucs-2,cp866

function! LANG_MAKEFILE()
   setlocal noexpandtab     " makefiles only work with tab-indents
   setlocal shiftwidth=8
   setlocal tabstop=8
   setlocal softtabstop=8
endfunction
autocmd FileType make call LANG_MAKEFILE()
