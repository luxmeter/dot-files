let mapleader = ","

" When F5 is pressed, a numbered list of file names is printed, and the user
" needs to type a single number based on the 'menu' and press enter.
nnoremap <F5> :Buffers<CR><Space>
nnoremap <C-N> :Files<CR>
nnoremap <C-P> "0p
nnoremap <C-S-P> "0P

nnoremap <Leader>b :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <Leader><F7> :YcmCompleter GoToReferences<CR>
nnoremap <Leader>q :YcmCompleter GetDoc<CR>
nnoremap <Leader>z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>

noremap <F7> mzgg=G`z

noremap <Leader>w :Bdelete!<CR>

" ycm related // to enable auto completion with c-space
" inoremap <C-Space> <C-x><C-o>
" imap <leader><space> <c-space>
" imap <C-@> <C-Space>
" imap <Nul> <C-Space>

noremap <Leader>s :w<CR>


nnoremap <F8> :setlocal spell! spell?<CR>
nnoremap ;; ;
nnoremap ; :

" delete line without copying the content to the yank register
" nnoremap <C-X> "_dd

" window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

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

" use space to toggle folds
nnoremap <Space> za
vnoremap <Space> za

" fix keys since tmux likes to break things
map OH <Home>
map OF <End>
imap OH <Home>
imap OF <End>

" Let Omnicompletion behave like you are used to from IDEs
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
" inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
" inoremap <silent><expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"
" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <Tab> pumvisible() ? "\<C-p>" : "\<Tab>"
