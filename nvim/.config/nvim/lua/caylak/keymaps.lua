local utils = require("caylak.utils")
local nmap = utils.nmap
local imap = utils.imap
local tmap = utils.tmap

nmap("<c-s-f1>", vim.diagnostic.open_float)
nmap("do", vim.diagnostic.open_float)
nmap("[d", vim.diagnostic.goto_prev)
nmap("]d", vim.diagnostic.goto_next)
nmap("dl", vim.diagnostic.setloclist)
nmap("dq", vim.diagnostic.setqflist)
nmap("<F9>", "mz:%SnipRun<CR>`z")

nmap("<tab>", ">>")
nmap("<s-tab>", "<<")
imap("<M-BS>", "<c-w>")

-- exit terminal with c-[
tmap("<c-[>", "<c-\\><c-n>")

vim.cmd([[
let mapleader = "\<space>"
let maplocalleader = "\<space>"
]])

vim.cmd([[
" fix annoying behaviour where pasting something into visual selection overrides the clipboard
xnoremap <expr> p 'pgv"'.v:register.'y'

noremap ,w :Bwipeout!<CR>
noremap ,s :w<CR>


nnoremap <F8> :setlocal spell! spell?<CR>

" sane remaps
nnoremap ;; ;
nnoremap ; :
nnoremap Y yg_
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
" populate undo
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap [ [<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
" move lines
vnoremap ]e :m '>+1<CR>gv=gv
vnoremap [e :m '<-2<CR>gv=gv
inoremap <C-k> <esc>:m .-2<CR>==i
inoremap <C-j> <esc>:m .+1<CR>==i
nnoremap [e :m .-2<CR>==
nnoremap ]e :m .+1<CR>==

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
nnoremap OH <Home>
nnoremap OF <End>
inoremap OH <Home>
inoremap OF <End>

nnoremap  <Home>
nnoremap  <End>
inoremap  <Home>
inoremap  <End>
]])
