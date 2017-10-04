"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
set rtp+=/usr/local/opt/fzf

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/syntastic'
Plugin 'jnurmine/Zenburn'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'terryma/vim-smooth-scroll'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'qpkorr/vim-bufkill'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-abolish'
" Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'tpope/vim-repeat'
Plugin 'mattn/emmet-vim'
Plugin 'mileszs/ack.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'sheerun/vim-polyglot'
Plugin 'tpope/vim-fugitive'		" wrapper around git cmds
Plugin 'airblade/vim-gitgutter' " shows quickdiffs
Plugin 'tpope/vim-commentary'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible		      " disable vi compatibility
set encoding=utf8
set ttyfast
set switchbuf=usetab
set splitright
set hidden
set backspace=indent,eol,start        " allow backspacing in insert mode
set scrolloff=3			      " show additional lines when scrolling at the end
set pastetoggle=<F2>
set clipboard=unnamed,unnamedplus     " copy into unnamed register to paste outside from vim (linux, windows = unnamed)
" set mouse=a			      " enable mouse movement - makes copy & paste hard to use

set ignorecase 			      " case insensitive
set smartcase  			      " use case if any caps used
set smarttab
set hlsearch " highlight search term

syntax on
set number				" show line numbers
set relativenumber		" show relative line numbers for fast movement
set laststatus=2		" show always status line
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set colorcolumn=120		" show right marin line (at reasonable 120 col width)
set cursorline			" highlight current line
set list
set listchars=tab:▸\ ,eol:¬ " shows symbols for tab and newline
set noswapfile			" helps if u want to use somekind of filesystem watcher
set nowritebackup
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Enable folding
set foldmethod=indent
set foldlevel=99

" wildcard ignore pattern
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/__pycache__/*,*.pyc  " Unix
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe						" Windows

set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

let mapleader = ","

" colorscheme zenburn
colorscheme Monokai

" augroup: http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
augroup reload_vimrc " {
	autocmd!
	" auto reload vimrc on save
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" remove trailing white spaces on save
augroup whitespaces " {
	autocmd!
	autocmd BufWritePre * %s/\s\+$//e
augroup END " }

" Save your swp files to a less annoying place than the current directory.
if isdirectory('~/.vim/swap') == 0
	:silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=~/.vim/swap//

" highlight cursor line
" hi cursorline cterm=none ctermbg=darkgray ctermfg=white

"define BadWhitespace before using in a match
highlight BadWhitespace ctermbg=red guibg=darkred
autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

augroup indentation " {
	autocmd!
	" execute command whenever vim sets the filetype to python
	" Python Indentation
	autocmd FileType python:
		\ set tabstop=4 |
		\ set softtabstop=4 |
		\ set shiftwidth=4 |
		\ set expandtab |
		\ set autoindent |
		\ set fileformat=unix

	" shell
	autocmd FileType sh,shell:
		\ set tabstop=2 |
		\ set softtabstop=2 |
		\ set shiftwidth=2 |
		\ set expandtab

	" Java
	autocmd FileType java:
		\ set tabstop=4 |
		\ set softtabstop=4 |
		\ set shiftwidth=4 |
		\ set expandtab

	autocmd BufNewFile,BufRead *.html,*.xml:
		\ set tabstop=2 |
		\ set softtabstop=2 |
		\ set shiftwidth=2
augroup END " }



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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Key Bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_auto_trigger=0

nnoremap <Leader>b :YcmCompleter GoToDefinitionElseDeclaration<CR>

map <F7> mzgg=G`z

" Ignores ctrl-space signal from the terminal
imap <Nul> <Nop>
map  <Nul> <Nop>
vmap <Nul> <Nop>
cmap <Nul> <Nop>
nmap <Nul> <Nop>

noremap <Leader>w :BD<CR>
noremap <Leader>s :w<CR>

nnoremap ; :

" remap increase and decrease
nnoremap <C-s> <C-x>

" delete line without copying the content to the yank register
nnoremap <C-X> "_dd

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

" clear current search results
nmap <silent> ,/ :nohlsearch<CR>

" keeps selection when moving code blocks
vnoremap < <gv
vnoremap > >gv

" dont show help when pressing f1 accidentally
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" esc insert mode with
inoremap jj <ESC>

" substitute word under the cursor
nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

" use space to toggle folds
nnoremap <Space> za
vnoremap <Space> za

" keep visual selection when moving lines
" egv is from vim-unimpaired
map <leader>a [egv
map <leader>d ]egv

" fix keys since tmux likes to break things
map OH <Home>
map OF <End>
imap OH <Home>
imap OF <End>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Variables
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts=1
let g:airline_enable_branch=1
let g:airline_enable_syntastic=1
let g:airline_detect_paste=1
let g:airline_theme='luna'

let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" enable all Python syntax highlighting features
let python_highlight_all = 1

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:Underline(chars)
	let chars = empty(a:chars) ? '-' : a:chars
	let nr_columns = virtcol('$') - 1
	let uline = repeat(chars, (nr_columns / len(chars)) + 1)
	put =strpart(uline, 0, nr_columns)
endfunction
command! -nargs=? Underline call s:Underline(<q-args>)

" Format JSON string
command! -range FormatJson <line1>,<line2>!python -m json.tool
command! -range FormatXml <line1>,<line2>!xmllint --format -

" Escape/unescape & < > HTML entities in range (default current line).
function! HtmlEntities(line1, line2, action)
	let search = @/
	let range = 'silent ' . a:line1 . ',' . a:line2
	if a:action == 0  " must convert &amp; last
		execute range . 'sno/&lt;/</eg'
		execute range . 'sno/&gt;/>/eg'
		execute range . 'sno/&amp;/&/eg'
	else              " must convert & first
		execute range . 'sno/&/&amp;/eg'
		execute range . 'sno/</&lt;/eg'
		execute range . 'sno/>/&gt;/eg'
	endif
	nohl
	let @/ = search
endfunction
command! -range -nargs=1 Entities call HtmlEntities(<line1>, <line2>, <args>)
noremap <silent> <Leader>h :Entities 0<CR>
noremap <silent> <Leader>H :Entities 1<CR>
