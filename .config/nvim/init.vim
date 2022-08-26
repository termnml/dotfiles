set nocompatible	" required
filetype off			" required

set rtp+=~/.config/nvim/bundle/Vundle.vim
" All Plugins after vundle#begin()
call vundle#begin('~/.config/nvim/bundle')

Plugin 'VundleVim/Vundle.vim'
Plugin 'preservim/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'rafi/awesome-vim-colorschemes'

Plugin 'PeterRincker/vim-searchlight'
Plugin 'jiangmiao/auto-pairs'
Plugin 'romainl/vim-cool'

Plugin 'sheerun/vim-polyglot'

" All Plugins before vundle#end()
call vundle#end()   " required
filetype plugin indent on " required
" to ignore plugin indent changes:
" filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" following the non-Plugin stuff

set number

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
set t_Co=256
"colorscheme peachpuff
"colorscheme molokai
colorscheme sonokai
set background=dark
" some colorscheme mods TODO: put in own colorscheme
"		 To customize a colorscheme use another name, e.g.
"		 ~/.vim/colors/mine.vim", and use :runtime to load
"		 the original colorscheme:
"		 runtime colors/evening.vim
"		 hi Statement ctermfg=Blue guifg=Blue
hi Search term=standout ctermfg=0 ctermbg=3 guifg=Black guibg=Yellow
hi MatchParen ctermfg=0 ctermbg=13 guibg=LightMagenta
"hi LineNr term=underline ctermfg=8
"hi VertSplit term=bold ctermfg=0
"hi Visual term=reverse cterm=reverse ctermbg=0 gui=reverse guifg=Grey80 guibg=fg
set guicursor=c-sm:block,n-v-i-ci-ve:ver25,r-cr-o:hor20
" Command for findig trailing whitespaces
hi ExtraWhitespace ctermbg=red guibg=red
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

let g:airline_theme='bubblegum'
let g:airline_powerline_fonts = 1

let mapleader=" "
" toggle line number
nnoremap <silent> <leader>n :set number!<CR>
" toggle line number style
nnoremap <silent> <C-n> :set rnu!<CR>
" remove assigned right from <Spcae>
nnoremap <Space> <nop>

" window movement
map <leader>h :wincmd h<CR>
map <leader>j :wincmd j<CR>
map <leader>k :wincmd k<CR>
map <leader>l :wincmd l<CR>

nmap <silent> <leader>pt :NERDTreeToggle<CR>

" experimental depends on terminal
xnoremap <silent> <M-k> :m-2<CR>gv=gv
xnoremap <silent> <M-j> :m '>+<CR>gv=gv
