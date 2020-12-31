set nocompatible " required
filetype off     " required

set shell=/usr/bin/bash
set rtp+=$HOME/.fzf

call plug#begin('~/.vim/plugged')

" misc
Plug 'airblade/vim-gitgutter'            " shows quickdiffs
Plug 'airblade/vim-rooter'
Plug 'bronson/vim-visual-star-search'
Plug 'godlygeek/tabular'                 " must come before vim-markdown
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs' " auto closing pairs
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'LumaKernel/fern-mapping-fzf.vim'
Plug 'lambdalisue/suda.vim'
Plug 'mileszs/ack.vim'
Plug 'moll/vim-bbye'                     " remove buffer while keeping window layout
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }
Plug 'rakr/vim-two-firewatch'
Plug 'sbdchd/neoformat'
Plug 'SirVer/ultisnips'
Plug 'skywind3000/asyncrun.vim'
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
" Plug 'plytophogy/vim-virtualenv' " slow
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'tmhedberg/SimpylFold'
Plug 'tweekmonster/impsort.vim'
Plug 'Vimjas/vim-python-pep8-indent'

" colorschemes
Plug 'ayu-theme/ayu-vim'                 " color scheme
Plug 'drewtempelmeyer/palenight.vim'
Plug 'flazz/vim-colorschemes'
Plug 'joshdick/onedark.vim'
Plug 'sonph/onehalf', {
            \ 'rtp': 'vim/'
            \ }

" syntax highlighting
Plug 'ekalinin/Dockerfile.vim'
Plug 'fatih/vim-go'
" Plug 'sheerun/vim-polyglot'            " syntax highlighting, slow

" web dev
Plug 'alvan/vim-closetag'
Plug 'leafgarland/typescript-vim'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'peitalin/vim-jsx-typescript'

call plug#end()
filetype plugin indent on               " activate filetype plugin
