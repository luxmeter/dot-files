-- reference: https://github.com/wincent/wincent/blob/main/aspects/nvim/files/.config/nvim/init.lua
local home = vim.env.HOME
local config = home .. "/.config/nvim"

vim.cmd("filetype indent plugin on")
vim.cmd("syntax on")

local o = vim.opt

o.autoindent = true -- maintain indent of current line
o.backspace = "indent,start,eol" -- allow unrestricted backspacing in insert mode
o.backup = false -- don't make backups before writing
o.backupcopy = "yes" -- overwrite files to update, instead of renaming + rewriting
o.backupskip = o.backupskip + "*.re,*.rei" -- prevent bsb's watch mode from getting confused (if 'backup' is ever set)
o.belloff = "all" -- never ring the bell for any reason
o.clipboard = { "unnamed", "unnamedplus" } -- copy into unnamed register to paste outside from vim (linux, windows = unnamed)
o.cmdheight = 2 -- more space in the neovim command line for displaying messages
o.completeopt = "menu,menuone,noinsert,noselect" -- for nvim-cmp
o.cursorline = true
o.cursorline = true -- highlight current line
o.diffopt = o.diffopt + "foldcolumn:0" -- don't show fold column in diff view
o.directory = config .. "/nvim/swap/" -- keep swap files out of the way
o.emoji = false -- don't assume all emoji are double width
o.encoding = "utf-8"
o.encoding = "utf8"
o.expandtab = true -- always use spaces instead of tabs
o.fillchars = {
	diff = "∙", -- BULLET OPERATOR (U+2219, UTF-8: E2 88 99)
	eob = " ", -- NO-BREAK SPACE (U+00A0, UTF-8: C2 A0) to suppress ~ at EndOfBuffer
	fold = "·", -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
	vert = "┃", -- BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
}
o.foldlevelstart = 99 -- start unfolded
o.foldmethod = "indent" -- not as cool as syntax, but faster
o.formatoptions = o.formatoptions + "j" -- remove comment leader when joining comment lines
o.formatoptions = o.formatoptions + "n" -- smart auto-indenting inside numbered lists
o.guifont = "Source Code Pro Light:h13"
o.hidden = true -- allows you to hide buffers with unsaved changes without being prompted
o.ignorecase = true -- case insensitive
o.inccommand = "split" -- live preview of :s results
o.joinspaces = false -- don't autoinsert two spaces after '.', '?', '!' for join command
o.laststatus = 3 -- always show status line
o.lazyredraw = true -- don't bother updating screen during macro playback
o.linebreak = true -- wrap long lines at characters in 'breakat'
o.list = true -- show whitespace
o.listchars = {
	nbsp = "⦸", -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
	extends = "»", -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
	precedes = "«", -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
	tab = "▷⋯", -- WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7) + MIDLINE HORIZONTAL ELLIPSIS (U+22EF, UTF-8: E2 8B AF)
	trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}
o.modelines = 5 -- scan this many lines looking for modeline
o.mouse = "a" -- enable mouse movement - makes copy & paste hard to use
o.number = true -- show line numbers in gutter
o.pastetoggle = "<F2>"
o.pumblend = 10 -- pseudo-transparency for popup-menu
o.pumheight = 10 -- pop up menu height
o.relativenumber = true -- show relative numbers in gutter
o.scrolloff = 3 -- start scrolling 3 lines before edge of viewport
o.shell = "zsh" -- shell to use for `!`, `:!`, `system()` etc.
o.shiftround = false -- don't always indent by multiple of shiftwidth
o.shiftwidth = 4 -- spaces per tab (when shifting)
o.shortmess = o.shortmess + "A" -- ignore annoying swapfile messages
o.shortmess = o.shortmess + "I" -- no splash screen
o.shortmess = o.shortmess + "O" -- file-read message overwrites previous
o.shortmess = o.shortmess + "T" -- truncate non-file messages in middle
o.shortmess = o.shortmess + "W" -- don't echo "[w]"/"[written]" when writing
o.shortmess = o.shortmess + "a" -- use abbreviations in messages eg. `[RO]` instead of `[readonly]`
o.shortmess = o.shortmess + "c" -- completion messages
o.shortmess = o.shortmess + "o" -- overwrite file-written messages
o.shortmess = o.shortmess + "t" -- truncate file messages at start
o.showbreak = "↳ " -- DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
o.showcmd = false -- don't show extra info at end of command line
o.sidescroll = 8 -- sidescroll in jumps because terminals are slow
o.sidescrolloff = 8 -- same as scrolloff, but for columns
o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
o.smartcase = true -- use case if any caps used
o.smarttab = true -- <tab>/<BS> indent/dedent in leading whitespace
o.softtabstop = -1 -- use 'shiftwidth' for tab/bs at end of line
o.spellcapcheck = "" -- don't check for capital letters at start of sentence
o.splitbelow = true -- open horizontal splits below current window
o.splitright = true -- open vertical splits to the right of the current window
o.suffixes = o.suffixes - ".h" -- don't sort header files at lower priority
o.swapfile = false -- don't create swap files
o.switchbuf = "usetab" -- try to reuse windows/tabs when switching buffers
o.synmaxcol = 200 -- don't bother syntax highlighting long lines
o.tabstop = 4 -- spaces per tab
o.termguicolors = true -- use guifg/guibg instead of ctermfg/ctermbg in terminal
o.textwidth = 0 -- automatically hard wrap at n columns
o.ttyfast = true
o.undofile = true
o.updatecount = 0 -- update swapfiles every 80 typed chars
o.updatetime = 300 -- CursorHold interval (def 400ms)
o.viewdir = config .. "/view" -- where to store files for :mkview
o.viewoptions = "cursor,folds" -- save/restore just these (with `:{mk,load}view`)
o.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
o.visualbell = true -- stop annoying beeping for non-error errors
o.whichwrap = "b,h,l,s,<,>,[,],~" -- allow <BS>/h/l/<Left>/<Right>/<Space>, ~ to cross line boundaries
o.wildcharm = 26 -- ('<C-z>') substitute for 'wildchar' (<Tab>) in macros
o.wildignore = o.wildignore + "*.o,*.rej,*.so" -- patterns to ignore during file-navigation
o.wildmenu = true -- show options as list when switching buffers etc
o.wildmode = "longest:full,full" -- shell-like autocomplete to unambiguous portion
o.winblend = 10 -- psuedo-transparency for floating windows
o.wrap = false -- wrap lines visually
o.writebackup = false -- don't keep backups after writing

vim.g.python3_host_prog = home .. "/.virtualenvs/nvimpy3/bin/python"

vim.cmd("colorscheme nightfox")
-- vim.cmd[[
-- let g:nord_contrast = 'false'
-- let g:nord_borders = 'true'
-- let g:material_style = 'palenight'
-- let g:codedark_conservative = 1
-- colorscheme codedark
-- ]]

if vim.fn.executable("rg") then
	local grep = {
		"rg",
		"--vimgrep",
		"--no-heading",
		"--smart-case",
		"--hidden",
		"--follow",
		"--no-ignore-global",
		"--ignore-file",
		vim.env.HOME .. "/.config/nvim/ignore-patterns",
	}
	local join = require("plenary.functional").join
	local result = join(grep, " ")
	o.grepprg = result
	o.grepformat = "%f:%l:%c:%m"
end

-- navigate via option arrow keys in macos within tmux
vim.cmd([[
cnoremap <C-A> <C-Home>
cnoremap <C-E> <C-End>
cnoremap <M-Up> <C-Home>
cnoremap <M-Down> <C-End>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

inoremap <C-A> <ESC>I
inoremap <C-E> <ESC>A
inoremap <M-Up> <ESC>I
inoremap <M-Down> <ESC>A
inoremap <M-b> <S-Left>
inoremap <M-f> <S-Right>
]])

--[[
After this file is sourced, plugin code will be evaluated (eg.
~/.config/nvim/plugin/* and so on ). See ~/.config/nvim/after for files
evaluated after that.  See `:scriptnames` for a list of all scripts, in
evaluation order.
Launch Neovim with `nvim --startuptime nvim.log` for profiling info.
To see all leader mappings, including those from plugins:
    nvim -c 'map <Leader>'
    nvim -c 'map <LocalLeader>'
--]]
