set backspace=indent,eol,start               " allow backspacing in insert mode
set clipboard=unnamed,unnamedplus            " copy into unnamed register to paste outside from vim (linux, windows = unnamed)
" set colorcolumn=120                          " show right marin line (at reasonable 120 col width)
set encoding=utf8
set foldlevel=99
set foldmethod=indent
set hidden
set hlsearch                                 " highlight search term
set ignorecase                               " case insensitive
set keywordprg=:help                         " don't open man page but vim's interal help on S-K
set laststatus=2                             " show always status line
set lazyredraw
set list
set listchars=tab:▸\ ,eol:¬                  " shows symbols for tab and newline
set mouse=a                                  " enable mouse movement - makes copy & paste hard to use
set noeol
set noswapfile                               " helps if u want to use somekind of filesystem watcher
set nowritebackup
set pastetoggle=<F2>
set norelativenumber                           " let the  menu flicker
set number
set scrolloff=3                              " show additional lines when scrolling at the end
set shiftwidth=4
set smartcase                                " use case if any caps used
set smarttab
set softtabstop=4
set splitbelow
set splitright
set statusline=%#warningmsg#
set statusline+=%*
set switchbuf=usetab
set tabstop=4
set termguicolors                            " enable true colors support
set ttyfast
set cursorline
syntax on

set completeopt=longest,menuone,preview,noinsert
set omnifunc=syntaxcomplete#Complete
set completefunc=syntaxcomplete#Complete
set complete=.,w,b,u,U,t,i,d

set tags=./tags;,tags,./.tags;,.tags
" let ayucolor="mirage"
" let ayucolor="light"
" colorscheme ayu
set background=light
colorscheme PaperColor

if executable('ag')
	set grepprg=ag\ --vimgrep\ $*
	set grepformat=%f:%l:%c:%m
	let g:ackprg = 'ag --vimgrep'
endif

" Save your swp files to a less annoying place than the current directory.
if isdirectory('~/.vim/swap') == 0
	:silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=~/.vim/swap//

" fix for background color bug in tmux
" see also http://sunaku.github.io/vim-256color-bce.html
if &term =~ '256color'
	" disable Background Color Erase (BCE) so that color schemes
	" render properly when inside 256-color tmux and GNU screen.
	" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
	set t_ut=
endif

if has('gui_macvim')
	set pythonhome=/usr/local/Frameworks/Python.framework/Versions/2.7
	set pythondll=/usr/local/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib
	set pythonthreehome=/Users/caylak/.pyenv/versions/3.6.4
	set pythonthreedll=/Users/caylak/.pyenv/versions/3.6.4/lib/libpython3.6m.dylib
	" test python2 and python3 in this order, otherwise a segmentfault will happen.
	silent! python print("+python2")
	silent! python3 print("+python3")
elseif has('nvim')
	" let g:python3_host_prog = '/Users/caylak/.pyenv/versions/3.6.4/bin/python3'
	let g:python3_host_prog = '/usr/local/bin/python3'
	let g:python2_host_prog = '/usr/local/Frameworks/Python.framework/Versions/2.7/bin/python'
	silent! python print("+python2")
	silent! python3 print("+python3")
endif
