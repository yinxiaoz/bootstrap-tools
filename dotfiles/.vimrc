set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim 

call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdcommenter'

Plugin 'scrooloose/nerdtree'

Plugin 'Yggdroot/indentLine'

Plugin 'morhetz/gruvbox'

Plugin 'vim-scripts/AutoComplPop'

Plugin 'honza/vim-snippets'

Plugin 'SirVer/ultisnips' 

Plugin 'Raimondi/delimitMate'

Plugin 'elzr/vim-json'

Plugin 'Glench/Vim-Jinja2-Syntax'

Plugin 'vim-scripts/BufOnly.vim'

Plugin 'Quramy/tsuquyomi'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Generic Config
set thesaurus+=~/.vim/mthesaur.txt
syntax on
set backupdir=~/.vim/backup
set background=dark
colorscheme gruvbox
set ruler                     " show the line number on the bar
set more                      " use more prompt
set autoread                  " watch for file changes
set number                    " line numbers
set hidden
set noautowrite               " don't automagically write on :next
set lazyredraw                " don't redraw when don't have to
set showmode
set showcmd
set nocompatible              " vim, not vi
set autoindent smartindent    " auto/smart indent
set smarttab                  " tab and backspace are smart
set tabstop=4                 " 4 spaces
set expandtab
set shiftwidth=4
set scrolloff=5               " keep at least 5 lines above/below
set sidescrolloff=5           " keep at least 5 lines left/right
set history=200
set backspace=indent,eol,start
set linebreak
set cmdheight=2               " command line two lines high
set undolevels=1000           " 1000 undos
set updatecount=100           " switch every 100 chars
set complete=.,w,b,u,U,t,i,d  " do lots of scanning on tab completion
set ttyfast                   " we have a fast terminal
set noerrorbells              " No error bells please
set shell=bash
set fileformats=unix
set ff=unix
filetype on                   " Enable filetype detection
filetype indent on            " Enable filetype-specific indenting
filetype plugin on            " Enable filetype-specific plugins
set wildmode=longest:full
set wildmenu                  " menu has tab completion
let maplocalleader=','        " all my macros start with ,
set laststatus=2
set shortmess+=A
set cursorline                " highlight current line
set guifont=Courier:h18
if bufwinnr(1)
    map + <C-W>+
    map - <C-W>-
endif

"  searching
set incsearch                 " incremental search
set ignorecase                " search ignoring case
set hlsearch                  " highlight the search
set showmatch                 " show matching bracket
set diffopt=filler,iwhite     " ignore all whitespace and sync
set smartcase

" vim-json
let g:vim_json_syntax_conceal = 0

"  backup
set backup
set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo
"set viminfo='100,f1
set noswapfile

" airline config
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" Control + l: move to next tab
" Control + h: move to prev tab
" Control + n: new tab
"map <C-l> :tabn<CR>
"map <C-h> :tabp<CR>
"map <C-n> :tabnew<CR>
" Move to the next buffer
map <C-n> :bnext<CR>

" Move to the previous buffer
map <C-p> :bprevious<CR>

" DelimitMate config
let delimitMate_expand_cr = 1

let g:indentLine_char = '|'

autocmd FileType python set colorcolumn=120
autocmd Syntax python normal zR

let g:NERDTreeWinSize=30

" spelling
if v:version >= 700
  " Enable spell check for text files
  autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en
endif

