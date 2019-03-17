set nocompatible              " required
filetype off                  " required

let s:uname = system("echo -n \"$(uname)\"")
if !v:shell_error && s:uname == "Linux"
	set rtp+=~/fzf
else
	let s:fzf_path = system("echo -n \"$(brew --prefix)/opt/fzf\"")
	exe 'set rtp+=' . expand(s:fzf_path)
endif

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter' " shows quickdiffs
Plug 'airblade/vim-rooter'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'ayu-theme/ayu-vim'
Plug 'bronson/vim-visual-star-search'
Plug 'ekalinin/Dockerfile.vim'
Plug 'fatih/vim-go'
Plug 'flazz/vim-colorschemes'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'jnurmine/Zenburn'
Plug 'jtratner/vim-flavored-markdown' " must come before vim-markdown
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'mileszs/ack.vim'
Plug 'moll/vim-bbye'
Plug 'rakr/vim-two-firewatch'
Plug 'Raimondi/delimitMate'
Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips'
Plug 'terryma/vim-smooth-scroll'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'		" wrapper around git cmds
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'

" Python plugins
Plug 'plytophogy/vim-virtualenv'
Plug 'tmhedberg/SimpylFold'
Plug 'tweekmonster/impsort.vim'
Plug 'vim-scripts/indentpython.vim'

" NCM2
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'

call plug#end()
filetype plugin indent on    " required
