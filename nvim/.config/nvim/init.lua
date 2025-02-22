vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- TODO check who is using { "nvim-tree/nvim-web-devicons", opts = {} },
vim.g.have_nerd_font = true

require("options")
require("keymaps")
require("lazy-bootstrap")
require("lazy-plugins")
require("autocmds")
