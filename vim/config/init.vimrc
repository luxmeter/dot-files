set nocompatible " required
filetype off     " required

set shell=/usr/local/bin/bash
set rtp+=$HOME/.fzf

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'            " shows quickdiffs
Plug 'airblade/vim-rooter'
Plug 'Raimondi/delimitMate'
Plug 'SirVer/ultisnips'
Plug 'ayu-theme/ayu-vim'                 " color scheme
Plug 'bronson/vim-visual-star-search'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'fatih/vim-go'
Plug 'flazz/vim-colorschemes'
Plug 'godlygeek/tabular'                 " must come before vim-markdown
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'mileszs/ack.vim'
Plug 'moll/vim-bbye'                     " remove buffer while keeping window layout
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rakr/vim-two-firewatch'
Plug 'sbdchd/neoformat'
" Plug 'sheerun/vim-polyglot'              " syntax highlighting, slow
Plug 'sonph/onehalf', {
            \ 'rtp': 'vim/'
            \ }
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'                  " file commands (move, delete...)
Plug 'tpope/vim-fugitive'                " wrapper around git cmds
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'                     " allows you to move the cursor in command line mode
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale' "decreases performance

" Python plugins
Plug 'tweekmonster/impsort.vim'
Plug 'tmhedberg/SimpylFold'
" Plug 'plytophogy/vim-virtualenv' " slow
Plug 'Vimjas/vim-python-pep8-indent'

" NCM2
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-ultisnips'

call plug#end()
filetype plugin indent on    " required
