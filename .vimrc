"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible		" disable vi compatibility
set encoding=utf8
set ttyfast
set switchbuf=usetab	" find buffers in existing windows also in tabs
set hidden				" hide unsaved documents in the background
set backspace=indent,eol,start	" allow backspacing in insert mode
set scrolloff=3			" show additional lines when scrolling at the end
set pastetoggle=<F2>	" to disable all smartness when pasting text
set clipboard=unnamed	" copy into unnamed register to paste outside from vim
" set mouse=a			" enable mouse movement - makes copy & paste hard to use

set tabstop=4			" a tab is defined by four spaces
set autoindent			" copy indent of the previous line
set copyindent			" copy the structure of the previous lines indent
set shiftwidth=0		" use tabstop's length for autoindent

set smartcase			" ignore case if search pattern is lowercase
set hlsearch			" highlight search term

syntax on
" set number				" show line numbers
set relativenumber		" show relative line numbers for fast movement
set laststatus=2		" show always status line
set colorcolumn=100		" show right marin line (at reasonable 120 col width)
set cursorline			" highlight current line
set list
set listchars=tab:▸\ ,eol:¬ " shows symbols for tab and newline

set foldenable			" enable folding
set foldlevelstart=10	" open most folds by default (up to 10)
set foldnestmax=10		" 10 nested folds max
set foldmethod=indent	" fold based on indent level

" wildcard ignore pattern
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/__pycache__/*,*.pyc  " Unix
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe						" Windows

" auto reload vimrc on save
augroup reload_vimrc " {
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Save your swp files to a less annoying place than the current directory.
if isdirectory('~/.vim/swap') == 0
	:silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=~/.vim/swap//

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visualization
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fix for background color bug in tmux
" see also http://sunaku.github.io/vim-256color-bce.html
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

colorscheme lucius
set background=light

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Key Bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap ; :
" use standard regex for the search
nnoremap / /\v
vnoremap / /\v

nnoremap <C-n> A<CR><ESC>	" new line on C-n

" smooth scrolling
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 25, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 25, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" buffer navigation
nnoremap <S-h> <ESC>:bprevious<CR>
nnoremap <S-l> <ESC>:bnext<CR>

" buffer navigation
nnoremap <S-h> <ESC>:bprevious<CR>
nnoremap <S-l> <ESC>:bnext<CR>

nmap <silent> ,/ :nohlsearch<CR>	" clear current search results

" keeps selection when moving code blocks
vnoremap < <gv
vnoremap > >gv

" remove trailing whitespaces on ,w
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" dont show help when pressing f1 accidentally
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" esc insert mode with
inoremap jj <ESC>

" substitute word under the cursor
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" use space to toggle folds
nnoremap <Space> za
vnoremap <Space> za

" keep visual selection when moving lines
map <leader>a [egv		" egv is from vim-unimpaired
map <leader>d ]egv

" fix keys since tmux likes to break things
map OH <Home>
map OF <End>
imap OH <Home>
imap OF <End>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pathogen - makes it easier to install/ remove 3rd party plugins
call pathogen#infect()
call pathogen#helptags()

" Closes Jedi's preview window for docstring on selection
autocmd CompleteDone * pclose
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python Related (Plugin-) Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jedi
let g:jedi#documentation_command = "<Leader>q"
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#auto_close_doc = 1
let g:jedi#goto_definitions_command = "<Leader>b"
let g:jedi#usages_command = "<Leader>u"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree Related Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <silent> <C-s> :NERDTree<CR><C-w>p:NERDTreeFind<CR>
let NERDTreeIgnore=['__pycache__[[dir]]', '.db$[[file]]', '.pyc$[[file]]']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTRL-P
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_open_multiple_files = 'ij'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UltraSnippet
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsListSnippets="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

