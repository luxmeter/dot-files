local map = function(mode, lhs, rhs, opts)
  local _opts = vim.tbl_deep_extend('force', { noremap = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, _opts)
end

local nmap = function(lhs, rhs, opts)
  map('n', lhs, rhs, opts)
end

local imap = function(lhs, rhs, opts)
  map('i', lhs, rhs, opts)
end

local vmap = function(lhs, rhs, opts)
  map('x', lhs, rhs, opts)
end

local tmap = function(lhs, rhs, opts)
  map('t', lhs, rhs, opts)
end

nmap('<c-s>', ':w<cr>')
nmap('<leader>`', '<c-^>')

-- nmap("<tab>", ">>")
-- nmap("<s-tab>", "<<")
nmap('[<space>', 'O<esc>cc<esc>')
nmap(']<space>', 'o<esc>cc<esc>')

-- Remap for dealing with word wrap
nmap('k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
nmap('j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

imap('<M-BS>', '<c-w>')
-- exit terminal with c-[
tmap('<c-[>', '<c-\\><c-n>')

nmap(',/', ':nohlsearch<CR>')

-- move line up and down
nmap('<A-j>', ':m .+1<CR>==') -- move line up(n)
nmap('<A-k>', ':m .-2<CR>==') -- move line down(n)
vmap('<A-j>', ':m .+1<CR>==') -- move line up(n)
vmap('<A-k>', ':m .-2<CR>==') -- move line down(n)

-- move to end of line (don't take include whitespaces)
map('n', '$', 'g_')
map('n', 'g_', '$')

-- buffers
map('n', '[b', '<cmd>bprev<cr>', { desc = 'Previous buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- copy and paste
map('n', '[p', '<cmd>Put *<cr>', { desc = 'Previous buffer' })
map('n', ']p', '<cmd>put *<cr>', { desc = 'Next buffer' })

-- tabs
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    if severity then
      go { severity = severity }
    else
      go {}
    end
  end
end
nmap('<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
nmap(']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next [E]rror' })
nmap('[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev [E]rror' })
nmap(']w', diagnostic_goto(true, 'WARN'), { desc = 'Next [W]arning' })
nmap('[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev [W]arning' })
nmap('<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- nmap('<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.cmd [[
" smooth scrooling
nnoremap <C-U> 6<C-Y>
nnoremap <C-D> 6<C-E>
" fix annoying behaviour where pasting something into visual selection overrides the clipboard
xnoremap <expr> p 'pgv"'.v:register.'y'

" nnoremap <F8> :setlocal spell! spell?<CR>

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

inoremap <C-k> <esc>:m .-2<CR>==i
inoremap <C-j> <esc>:m .+1<CR>==i

" delete line without copying the content to the yank register
" c-s-d does not work in neovim :(
" map ^[[68;5u>   :echo "ctrl-shift-d received"<CR>
" map <C-d> "_dd
noremap <Leader>d "_dd

" buffer navigation
" nnoremap <S-h> <ESC>:bprevious<CR>
" nnoremap <S-l> <ESC>:bnext<CR>

" keeps selection when moving code blocks
vnoremap < <gv
vnoremap > >gv

" dont show help when pressing f1 accidentally
" inoremap <F1> <ESC>
" nnoremap <F1> <ESC>
" vnoremap <F1> <ESC>

" esc insert mode with
inoremap jj <ESC>

" don't jump to next hit
" map * *``
" vmap * *``

" center viewport when navigating the quicklist
nnoremap ]q :cn<cr> z.
nnoremap [q :cp<cr> z.

" fix keys since tmux likes to break things
nnoremap OH <Home>
nnoremap OF <End>
cnoremap OH <Home>
cnoremap OF <End>
inoremap OH <Home>
inoremap OF <End>

cnoremap  <Home>
cnoremap  <End>
inoremap  <Home>
inoremap  <End>
]]
