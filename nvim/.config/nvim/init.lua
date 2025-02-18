require 'options'

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  local repo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', repo, '--branch=stable', lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({ import = 'plugins' }, {
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false, -- get a notification when changes are found
  },
})

require 'autocmds'
require 'mappings'

if vim.fn.executable 'rg' then
  local grep = {
    'rg',
    '--vimgrep',
    '--no-heading',
    '--smart-case',
    '--hidden',
    '--follow',
    '--iglob',
    '!lazy-lock.json',
  }

  local join = require('plenary.functional').join
  local result = join(grep, ' ')
  vim.o.grepprg = result
  vim.o.grepformat = '%f:%l:%c:%m'
end
