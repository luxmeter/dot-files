"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible		      " disable vi compatibility
set noeol
set encoding=utf8
set ttyfast
set switchbuf=usetab
set splitright
set hidden
set backspace=indent,eol,start        " allow backspacing in insert mode
set scrolloff=3			      " show additional lines when scrolling at the end
set pastetoggle=<F2>
set clipboard=unnamed,unnamedplus     " copy into unnamed register to paste outside from vim (linux, windows = unnamed)
set mouse=a			      " enable mouse movement - makes copy & paste hard to use

set ignorecase 			      " case insensitive
set smartcase  			      " use case if any caps used
set smarttab
set hlsearch " highlight search term

syntax on
set number				" show line numbers
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set colorcolumn=120		" show right marin line (at reasonable 120 col width)
" set cursorline			" highlight current line
set termguicolors     " enable true colors support
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

" performance improvement
set lazyredraw
" set relativenumber		" show relative line numbers for fast movement
set laststatus=2		" show always status line

" wildcard ignore pattern
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/__pycache__/*,*.pyc  " Unix
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe						" Windows

set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

" to search for help for the word under the cursor
set keywordprg=:help

set omnifunc=syntaxcomplete#Complete
" set completeopt-=preview

" let ayucolor="light"
let ayucolor="mirage"
" let ayucolor="dark"
" colorscheme Monokai
colorscheme ayu

" highlight cursor line
" hi cursorline cterm=none ctermbg=darkgray ctermfg=white

"define BadWhitespace before using in a match
highlight BadWhitespace ctermbg=red guibg=darkred

if executable('ag')
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AutoGroups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup filetype_detection " {
	autocmd!
	autocmd FileType html,xhtml
				\ set filetype=xml
augroup END " }

" augroup: http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
augroup reload_vimrc " {
	autocmd!
	" auto reload vimrc on save
	autocmd BufWritePost $MYVIMRC,*.vimrc source $MYVIMRC | silent! AirlineRefresh
augroup END " }

" remove trailing white spaces on save
augroup whitespaces " {
	autocmd!
	autocmd BufWritePre * %s/\s\+$//e
	" query, ag options, fzf#run options, fullscreen
	autocmd VimEnter *
	\ command! -bang -nargs=* Ag
	\ call fzf#vim#ag(<q-args>, '', { 'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all' }, <bang>0)
augroup END " }

" entering insert mode changes the current dir to the current dir of the
" opened file --> comes handy when using c-x-f for file completion
augroup autocd " {
	autocmd!
	autocmd BufRead,BufNewFile *yaml,*.md,*.txt,gitcommit setlocal spell | setlocal complete+=kspell
	autocmd BufWritePre *.py ImpSort!
	autocmd InsertEnter * let save_cwd = getcwd() | set autochdir
	autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(save_cwd)
	autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
	autocmd InsertLeave * if pumvisible() == 0|pclose|endif
	autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
	autocmd FileType html,css EmmetInstall
augroup END " }

" fix newtr buffer bug
" https://vi.stackexchange.com/questions/14622/how-can-i-close-the-netrw-buffer
set nohidden
augroup netrw_buf_hidden_fix
    autocmd!
    " Set all non-netrw buffers to bufhidden=hide
    autocmd BufWinEnter *
                \  if &ft != 'netrw'
                \|     set bufhidden=hide
                \| endif
augroup end
