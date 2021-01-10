let mapleader = "\<space>"
" When F5 is pressed, a numbered list of file names is printed, and the user
" needs to type a single number based on the 'menu' and press enter.
nnoremap <silent><c-n> :Files<CR>
nnoremap <silent><leader>n :execute 'FZF ' . FindRootDirectory()<CR>
nnoremap <silent><leader>c :execute 'Commands'<CR>
nnoremap <silent><leader>e :Buffers<CR>
nmap // :BLines!<CR>
nmap ?? :Rg!<CR>
nnoremap <Leader>d "0d
nnoremap <Leader><S-d> "0D
vnoremap <Leader>d "0d
vnoremap <Leader><S-d> "0D

vnoremap p pgvy
xnoremap p pgvy
vnoremap P Pgvy
xnoremap P Pgvy

noremap <c-w> :Bwipeout!<CR>
noremap <c-s> :w<CR>


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
" inoremap <F1> <ESC>
" nnoremap <F1> <ESC>
" vnoremap <F1> <ESC>

" esc insert mode with
inoremap jj <ESC>

" substitute word under the cursor
" recursive mapping in order to use visual-star-search
nnoremap <leader>r g*<c-o>:%s/<c-r>//<c-r>//g<left><left>
vmap <leader>r *<c-o>:%s/<c-r>//<c-r>//g<left><left>

" don't jump to next hit
map * *``
vmap * *``

" center viewport when navigating the quicklist
nnoremap ]q :cn<cr> z.
nnoremap [q :cp<cr> z.

" fix keys since tmux likes to break things
map OH <Home>
map OF <End>
imap OH <Home>
imap OF <End>


" Let Omnicompletion behave like you are used to from IDEs
" don't add tab cycling if Coc is used (it comes with its own mapping)
inoremap <expr> <Esc>       pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <Down>      pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>        pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown>  pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>    pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

nnoremap <F9> :w<CR>:call RunFile()<CR>
inoremap <F9> <C-[>:call RunFile()<CR>
