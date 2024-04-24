
" Make UTF-8 the default encoding
set encoding=utf8

" Show matching brackets when the cursor is above them
set showmatch

" Do not create backup file, we're old enough to use git
set nobackup
set noswapfile

" Make tabstops 4 spaces wide
" Use :retab to convert tabs to spaces
set expandtab      " TABs are SPACEs
set tabstop=4      " Number of visual spaces per TAB
set softtabstop=4  " Actual number of spaces inserted
set shiftwidth=4
set smarttab       " Tabs go to the next tabstop

" Enable autoindent - indentation is preserved when pressing ENTER
set autoindent
filetype indent on " Load file specific indentation rules

" Visual tweaks
set number         " Show line numbers always
set cursorline     " Highlight the current line
set list listchars=tab:→\ ,trail:· " Show trailing tabs and spaces

" Search settings
set incsearch      " Search as characters are entered
set hlsearch       " Highlight matches

" Whitespace handling
" Strip trailing whitespace on lines
autocmd BufWritePre * :%s/\s\+$//e

" Shift+Tab unindents a line "
imap <S-Tab> <Esc><<i
nmap <S-tab> <<

syntax on          " Make it pretty!
filetype plugin on

" Filetype specific config
" Makefile: use _real_ tabs
autocmd FileType make
	\ set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
