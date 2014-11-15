" powerline
set rtp+=/usr/lib/python2.7/site-packages/powerline/bindings/vim/
let g:Powerline_symbols = 'fancy'


" general settings
set encoding=utf-8
set nocompatible  	" disable vi-compatibility
set laststatus=2	" always show the statusline
set colorcolumn=80	" add max column width border
set cursorline		" highlight current line
set switchbuf=usetab " doesn't show an already opened buffer in a new window
set hidden			" hides unsaved documents in a background buffer
set tabstop=4     	" a tab is four spaces
set backspace=indent,eol,start " allow backspacing in insert mode
set number        	" always show line numbers
set autoindent		" autoindentation
set copyindent		" copy previous indentation on autoindenting
set shiftwidth=4	" number of spaces to use for autoindenting
set shiftround		" use multiple of shiftwidth when indenting
set showmatch     	" show matching parenthesis
set smartcase     	" ignore case if search pattern is all lowercase
set smarttab		" insert tabs on the start of a line with shiftwidth
set hlsearch		" highlight search terms
set mouse=a			" enable mouse in vim
set nofoldenable	" don't fold automatically
set scrolloff=3
set gdefault		" substitue on all lines
set list
set listchars=tab:▸\ ,eol:¬ " shows symbols for tab and newline
set ttyfast
syntax on
"set t_Co=256		" 256 colors in vim
"let g:rehash256 = 1
colorscheme lucius
set background=light
let mapleader=","	" map leader key from / to ,

" dissables all smartness in order to paste text in insert mode
set pastetoggle=<F2>
set clipboard=unnamed


" vim specific settings
" auto reload vimrc on save
augroup reload_vimrc " {
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
	:silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.


" filetype specific settings
filetype plugin indent on
autocmd filetype python set expandtab


" gui settings
set guifont=Droid\ Sans\ Mono\ for\ Powerline


" custom mappings
" map : to ;
nnoremap ; :
" use standard regex for search
nnoremap / /\v
vnoremap / /\v
nnoremap <C-n> i<CR><ESC>	" new line on Ctrl+n
" window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" buffer navigation
nnoremap <S-h> <ESC>:bprevious<CR>
nnoremap <S-l> <ESC>:bnext<CR>
" format current paragraph
vmap Q gq
nmap Q gqap
nmap <silent> ,/ :nohlsearch<CR> " clear current search results
" keeps selection when moving code blocks
vnoremap < <gv
vnoremap > >gv
vnoremap <Leader><S-s> :sort<CR> " sort on ,s
" remove trailing whitespaces on ,w
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" dont show help when pressing f1 accidentally
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
" esc insert mode with
inoremap jj <ESC>
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" 3rd party settings
" pathogon plugin
" makes it easier to install/ remove 3rd party plugins
call pathogen#infect()
call pathogen#helptags()


" (python) jedi
let g:jedi#documentation_command = "<Leader>q"
let g:jedi#use_tabs_not_buffers = 0

" python mode
let g:pymode_rope = 0
let g:pymode_breakpoint = 0
let g:pymode_syntax = 1
let g:pymode_syntax_builtin_objs = 0
let g:pymode_syntax_builtin_funcs = 0
let g:pymode_lint = 1
let g:pymode_lint_on_write = 1

" nerd tree
map <silent> <C-s> :NERDTree<CR><C-w>p:NERDTreeFind<CR>
let NERDTreeIgnore=['__pycache__[[dir]]', '.db$[[file]]']

" python debug
map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

" ctrlp-plugin: ignore file pattern
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/__pycache__/*     " Linux/MacOSX
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_open_multiple_files = 'ij'

" smooth scrolling
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 25, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 25, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" ultisnippets
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsListSnippets="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories=["UltiSnips"]
