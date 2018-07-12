set nocompatible              " required
filetype off                  " required

let s:uname = system("echo -n \"$(uname)\"")
if !v:shell_error && s:uname == "Linux"
	set rtp+=~/.fzf
else
	let s:fzf_path = system("echo -n \"$(brew --prefix)/opt/fzf\"")
	exe 'set rtp+=' . expand(s:fzf_path)
endif
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'Raimondi/delimitMate'
Plugin 'Shougo/deoplete.nvim'
Plugin 'SirVer/ultisnips'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'airblade/vim-gitgutter' " shows quickdiffs
Plugin 'airblade/vim-rooter'
Plugin 'ayu-theme/ayu-vim'
Plugin 'bronson/vim-visual-star-search'
Plugin 'flazz/vim-colorschemes'
Plugin 'godlygeek/tabular'
Plugin 'honza/vim-snippets'
Plugin 'jnurmine/Zenburn'
Plugin 'jtratner/vim-flavored-markdown'
Plugin 'junegunn/fzf.vim'
Plugin 'mattn/emmet-vim'
Plugin 'mileszs/ack.vim'
Plugin 'moll/vim-bbye'
Plugin 'sheerun/vim-polyglot'
Plugin 'terryma/vim-smooth-scroll'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'		" wrapper around git cmds
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'w0rp/ale'

" Python plugins
Plugin 'plytophogy/vim-virtualenv'
Plugin 'tmhedberg/SimpylFold'
Plugin 'tweekmonster/impsort.vim'
Plugin 'vim-scripts/indentpython.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
