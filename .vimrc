set number
set relativenumber

set linebreak
set showbreak=»
"set showmatch
set textwidth=100
"set visualbell

set hlsearch
"set smartcase
"set ignorecase
set incsearch

set autoindent
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2

set ruler

set undolevels=1000
set backspace=indent,eol,start

syntax on
" sets the colors to base16 from terminal
set t_Co=16
colorscheme delek

let mapleader=" "
" toggle line number
nnoremap <silent> <leader>n :set number!<CR>:set rnu!<CR>
" remove assigned right from <Spcae>
nnoremap <Space> <nop>
map <leader>h :wincmd h<CR>
map <leader>j :wincmd j<CR>
map <leader>k :wincmd k<CR>
map <leader>l :wincmd l<CR>
" fast-quit
nmap <C-q> :q <CR>
