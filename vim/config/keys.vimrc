let mapleader = ","

" When F5 is pressed, a numbered list of file names is printed, and the user
" needs to type a single number based on the 'menu' and press enter.
nnoremap <silent><C-N> :FZF<CR>
nnoremap <silent><Leader><Leader> :execute 'FZF ' . FindRootDirectory()<CR><CR>
nmap // :BLines!<CR>
nmap ?? :Ag!<CR>
nnoremap <Leader>d "0d
nnoremap <Leader><S-d> "0D
vnoremap <Leader>d "0d
vnoremap <Leader><S-d> "0D
nnoremap <Leader>e :Buffers<CR>

vnoremap p pgvy
xnoremap p pgvy
vnoremap P Pgvy
xnoremap P Pgvy

noremap <F7> mzgg=G`z

noremap <Leader>w :Bwipeout!<CR>

noremap <Leader>s :w<CR>


nnoremap <F8> :setlocal spell! spell?<CR>
nnoremap ;; ;
nnoremap ; :

" delete line without copying the content to the yank register
" c-s-d does not work in neovim :(
" map ^[[68;5u>   :echo "ctrl-shift-d received"<CR>
" map <C-d> "_dd
noremap <Leader>d "_dd
noremap <Leader>y yyp
noremap <Leader>h H
noremap <Leader>l L
noremap <Leader>m M

" window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" move cursor up/down also in wrapped lines
nnoremap j gj
nnoremap k gk

" buffer navigation
nnoremap <S-h> <ESC>:bprevious<CR>
nnoremap <S-l> <ESC>:bnext<CR>

" clear current search results
nnoremap <silent> ,/ :nohlsearch<CR>

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

" fix keys since tmux likes to break things
map OH <Home>
map OF <End>
imap OH <Home>
imap OF <End>


" Let Omnicompletion behave like you are used to from IDEs
inoremap <expr> <Esc>       pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <Down>      pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>        pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown>  pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>    pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

nnoremap <F9> :w<CR>:call RunFile()<CR>
inoremap <F9> <C-[>:call RunFile()<CR>
