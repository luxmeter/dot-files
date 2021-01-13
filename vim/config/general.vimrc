set autowrite
set backspace=indent,eol,start    " allow backspacing in insert mode
set clipboard=unnamed,unnamedplus " copy into unnamed register to paste outside from vim (linux, windows = unnamed)
" set colorcolumn=120             " show right marin line (at reasonable 120 col width)
set cmdheight=2                   " Give more space for displaying messages
set cursorline
set encoding=utf8
set expandtab
set foldlevelstart=99             " start unfolded
" set foldmethod=syntax
set fillchars=vert:┃
set fillchars+=fold:·
set foldtext=wincent#settings#foldtext()
set hidden
set hlsearch                      " highlight search term
set ignorecase                    " case insensitive
set keywordprg=:help              " don't open man page but vim's interal help on S-K
set laststatus=2                  " show always status line
set lazyredraw
set list
set listchars=tab:▸\ ,eol:¬       " shows symbols for tab and newline
set mouse=a                       " enable mouse movement - makes copy & paste hard to use
set nobackup                      " Some servers have issues with backup files, see #649.
set noeol
set relativenumber              " let the  menu flicker
set noswapfile                    " helps if u want to use somekind of filesystem watcher
set nowritebackup
set pastetoggle=<F2>
set scrolloff=3                   " show additional lines when scrolling at the end
set shiftwidth=4
set signcolumn=yes                " Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
set shortmess+=c                  " Don't pass messages to |ins-completion-menu|.
" set shortmess=aOItT
set smartcase                     " use case if any caps used
set smarttab
set softtabstop=4
set splitbelow
set splitright
" set statusline+=%*
set statusline=%#warningmsg#
set switchbuf=usetab
set tabstop=4
set termguicolors                 " enable true colors support
set timeoutlen=300                " e.g. time to enter jj(c-]) in insert mode
set ttyfast
set updatetime=300                " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
syntax on

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect,preview
set omnifunc=syntaxcomplete#Complete
set completefunc=syntaxcomplete#Complete
set complete=.,w,b,u,U,t,i,d

set tags=./tags;,tags,./.tags;,.tags
set background=dark " or light if you prefer the light version
" colorscheme onehalfdark
" colorscheme Tomorrow-Night
colorscheme onedark

" if &diff
"     colorscheme jellybeans
" endif

if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow\ --no-heading
    set grepformat=%f:%l:%c:%m
endif

" Save your swp files to a less annoying place than the current directory.
if isdirectory($HOME.'/.vim/swap') == 0
    :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=~/.vim/swap//

" " fix for background color bug in tmux
" " see also http://sunaku.github.io/vim-256color-bce.html
" if &term =~ '256color'
"     " disable Background Color Erase (BCE) so that color schemes
"     " render properly when inside 256-color tmux and GNU screen.
"     " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
"     set t_ut=
" endif

let g:python3_host_prog = $HOME. '/.virtualenvs/nvimpy3/bin/python'
