set nocompatible
set encoding=utf-8
set directory=~/tmp/vimswap   " put .swp files here
syntax enable

let mapleader = ","

set guifont=Bitstream\ Vera\ Sans\ Mono\ 8 
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation


set mouse=a

"" Appearance
set number           " show line numbers
set ruler            " ruler display in status line
set showmatch        " show matching brackets
set title
set visualbell
"" color default

"" Searching
set hlsearch           " highlight matches
set incsearch          " incremental searching
set ignorecase
set smartcase
set wrapscan           " search around end of file
set list


set history=1000

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

