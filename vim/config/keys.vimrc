"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Key Bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

" When F5 is pressed, a numbered list of file names is printed, and the user
" needs to type a single number based on the 'menu' and press enter.
:nnoremap <F5> :Buffers<CR>:buffer<Space>
:nnoremap <C-P> :Files<CR>

let g:user_emmet_install_global = 0

" python3 completion
let g:ycm_python_binary_path="python3"
let g:ycm_auto_trigger=0
" YCM will auto-close the 'preview' window after the user accepts the offered completion string.
let g:ycm_autoclose_preview_window_after_completion=1
" Defines where GoTo* commands result should be opened. Can take one of the
" following values: [ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab', 'new-or-existing-tab' ]
let g:ycm_goto_buffer_command = 'same-buffer'
let g:syntastic_python_python_exec = '/usr/bin/python3'

nnoremap <Leader>b :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <Leader><F7> :YcmCompleter GoToReferences<CR>

map <F7> mzgg=G`z

" ycm related // to enable auto completion with c-space
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
imap <Nul> <C-Space>

noremap <Leader>w :BD<CR>
" Ignores ctrl-space signal from the terminal
" imap <Nul> <Nop> " needs to be commented out if you want to use ctrl-space
" for completion
map  <Nul> <Nop>
vmap <Nul> <Nop>
cmap <Nul> <Nop>
nmap <Nul> <Nop>

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

" move cursor up/down also in wrapped lines
nnoremap j gj
nnoremap k gk

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

"fzf bindings
" This is the default extra key bindings
let g:fzf_action = {
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-x': 'split',
			\ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
	call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
	copen
	cc
endfunction

let g:fzf_action = {
			\ 'ctrl-q': function('s:build_quickfix_list'),
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-x': 'split',
			\ 'ctrl-v': 'vsplit' }

" Let Omnicompletion behave like you are used to from IDEs
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
