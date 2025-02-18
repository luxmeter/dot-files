vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showbreak = '↳ '

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true

vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- If this many milliseconds nothing is typed the swap file will be written to disk
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

vim.opt.autoindent = true -- maintain indent of current line (default)
vim.bo.smartindent = true -- Do smart autoindent when starting a new line
vim.opt.backspace = 'indent,start,eol' -- allow unrestricted backspacing in insert mode
vim.opt.expandtab = true -- always use spaces instead of tabs
vim.opt.emoji = false -- don't assume all emoji are double width

vim.opt.fillchars = {
  diff = '∙', -- BULLET OPERATOR (U+2219, UTF-8: E2 88 99)
  eob = ' ', -- NO-BREAK SPACE (U+00A0, UTF-8: C2 A0) to suppress ~ at EndOfBuffer
  fold = '·', -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
  vert = '┃', -- BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
}
vim.opt.formatoptions = vim.opt.formatoptions + 'j' -- remove comment leader when joining comment lines
vim.opt.formatoptions = vim.opt.formatoptions + 'n' -- smart auto-indenting inside numbered lists
vim.opt.joinspaces = false -- don't autoinsert two spaces after '.', '?', '!' for join command
vim.opt.list = true -- show whitespace
vim.opt.smarttab = true -- <tab>/<BS> indent/dedent in leading whitespace
vim.opt.softtabstop = -1 -- use 'shiftwidth' for tab/bs at end of line
vim.opt.tabstop = 4 -- spaces per tab
vim.opt.shiftwidth = 4 -- spaces per indent level
vim.opt.writebackup = false -- don't keep backups after writing
vim.opt.termguicolors = true -- NOTE: You should make sure your terminal supports this
vim.opt.cmdheight = 1

-- vim.opt.winblend = 10 -- pseudo-transparency
-- vim.opt.pumblend = 10 -- pseudo-transparency for popup-menu
-- vim.opt.pumheight = 10 -- pop up menu height

vim.opt.shell = 'zsh' -- shell to use for `!`, `:!`, `system()` etc.

vim.opt.shortmess = vim.opt.shortmess + 'A' -- ignore annoying swapfile messages
vim.opt.shortmess = vim.opt.shortmess + 'I' -- no splash screen
vim.opt.shortmess = vim.opt.shortmess + 'O' -- file-read message overwrites previous
vim.opt.shortmess = vim.opt.shortmess + 'T' -- truncate non-file messages in middle
vim.opt.shortmess = vim.opt.shortmess + 'W' -- don't echo "[w]"/"[written]" when writing
vim.opt.shortmess = vim.opt.shortmess + 'a' -- use abbreviations in messages eg. `[RO]` instead of `[readonly]`
vim.opt.shortmess = vim.opt.shortmess + 'c' -- completion messages
vim.opt.shortmess = vim.opt.shortmess + 'o' -- overwrite file-written messages
vim.opt.shortmess = vim.opt.shortmess + 't' -- truncate file messages at start
vim.opt.shortmess = vim.opt.shortmess + 's' -- "search hit BOTTOM"
vim.opt.shortmess = vim.opt.shortmess + 'C' -- don't give messages while scanning for ins-completion items, for instance "scanning tags"vim.opt.showcmd = true -- don't show extra info at end of command line
vim.opt.sidescroll = 8 -- sidescroll in jumps because terminals are slow
vim.opt.sidescrolloff = 8 -- same as scrolloff, but for columns

vim.opt.showbreak = '↳ ' -- DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)

vim.opt.spellcapcheck = '' -- don't check for capital letters at start of sentence
vim.opt.switchbuf = 'usetab' -- when switching buffers focus windows/tabs where they are already opened
vim.opt.synmaxcol = 200 -- don't bother syntax highlighting long lines
vim.opt.ttyfast = true

vim.opt.whichwrap = 'b,h,l,s,<,>,[,],~' -- allow <BS>/h/l/<Left>/<Right>/<Space>, ~ to cross line boundaries
vim.opt.wildcharm = 26 -- ('<C-z>') substitute for 'wildchar' (<Tab>) in macros
vim.opt.wildignore = '*.o,*.rej,*.so' -- patterns to ignore during file-navigation
vim.opt.wildmenu = true -- show options as list when switching buffers etc
vim.opt.wildmode = 'longest:full,full' -- shell-like autocomplete to unambiguous portion

vim.opt.wrap = false -- wrap lines visually
vim.opt.textwidth = 0 -- automatically hard wrap at n columns
-- vim.opt.colorcolumn = '120' -- highlight column 120
vim.opt.conceallevel = 0 -- don't hide text with conceal

vim.opt.statuscolumn = [[%!v:lua.require'util'.statuscolumn()]]

vim.wo.foldlevel = 10

-- diagnostics
local signs = {
  { name = 'DiagnosticSignError', text = '' },
  { name = 'DiagnosticSignWarn', text = '' },
  { name = 'DiagnosticSignHint', text = '' },
  { name = 'DiagnosticSignInfo', text = '' },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

local config = {
  signs = {
    active = signs, -- show signs
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = 'single',
    source = 'always',
    header = 'Diagnostic',
    prefix = '',
  },
}

vim.diagnostic.config(config)
