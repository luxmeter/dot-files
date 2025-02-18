return {
  {
    -- improvement user experience
    'mbbill/undotree',
    enabled = true,
    keys = {
      { '<leader>u', vim.cmd.UndotreeToggle, desc = 'Toggle undotree' },
    },
  }, -- undotree
  {
    'famiu/bufdelete.nvim',
    enabled = true,
    keys = {
      {
        ',w',
        function()
          local force = true
          require('bufdelete').bufdelete(0, not force)
        end,
        desc = 'Delete buffer',
      },
    },
  },
  { 'bronson/vim-visual-star-search', enabled = true }, -- make * search work as expectd
  { 'godlygeek/tabular', enabled = true, cmd = { 'Tabularize' } }, -- align text by pattern
  { 'lambdalisue/suda.vim', enabled = true, cmd = { 'SudaWrite', 'SudaRead' } }, -- workaround for sudo-bug in neovim (:SudaWrite,
  -- {
  --   'karb94/neoscroll.nvim',
  --   opts = {},
  -- },
  { 'stefandtw/quickfix-reflector.vim', enabled = true }, -- reflect changes in quickfix buffer
  { 'tpope/vim-abolish', enabled = true }, -- better substitution, e.g. :%Subvert/facilit{y,ies}/building{,s}/g
  { 'tpope/vim-eunuch', enabled = true }, -- file commands (move, delete...,
  -- {'tpope/vim-repeat'}, -- make vim repeat (., work as expected
  { -- automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file -> startup performance killer for large files
    'tpope/vim-sleuth',
    config = function()
      -- big files are mostly log files so don't apply heuristics for the sake of performance
      vim.g.sleuth_text_heuristics = 0
    end,
  },
  -- 'tpope/vim-surround', -- replaced by mini-surround
  -- "tpope/vim-unimpaired" -- useful key-bindings for cn ([c), bn ([b, and such
  -- Git related plugins
  { 'tpope/vim-fugitive', enabled = true },
  { 'tpope/vim-rhubarb', enabled = false },
  { 'vim-scripts/loremipsum', enabled = true }, -- loremipsum generator
  { 'anuvyklack/pretty-fold.nvim', enabled = true }, -- prettier folds
  -- { "sunjon/shade.nvim", opts = {} }, -- dim inactive window (buggy)
  {
    'tversteeg/registers.nvim', -- view registers
    name = 'registers',
    enabled = true,
    keys = {
      { '"', mode = { 'n', 'v' } },
      { '<C-R>', mode = 'i' },
    },
    cmd = 'Registers',
    opts = {},
  },
  { 'nvim-pack/nvim-spectre', enabled = true, dependencies = { 'nvim-lua/plenary.nvim' }, opts = {}, cmd = { 'Spectre' } }, -- find & replace in project

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', enabled = true, event = { 'VeryLazy' }, dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', event = { 'VeryLazy' }, enabled = true, opts = {} },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    event = { 'VeryLazy' },
    enabled = true,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = true }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        -- local charcount = 0
        -- local mode = vim.fn.mode()
        -- if mode == 'v' or mode == 'V' then
        --   -- [bufnum, lnum, col, off]
        --
        --   local _, lstart, colstart, _ = unpack(vim.fn.getcharpos(mode))
        --   -- local _, lend, colend, _ = unpack(vim.fn.getcharpos "'>")
        --   local _, lend, colend, _, _ = unpack(vim.fn.getcursorcharpos(vim.api.nvim_get_current_win()))
        --   for i = lstart, lend do
        --     print(lstart, lend, colstart, colend)
        --   end
        --
        --   charcount = (colend - colstart)
        -- end
        return '%2l:%-2v'
      end

      statusline.active = function()
        local _, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
        local git = MiniStatusline.section_git { trunc_width = 75 }
        local diagnostics = MiniStatusline.section_diagnostics {
          trunc_width = 75,
          icon = ' ',
        }
        local filename = MiniStatusline.section_filename { trunc_width = 140 }
        local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
        local location = MiniStatusline.section_location { trunc_width = 75 }
        local search = MiniStatusline.section_searchcount { trunc_width = 75 }
        -- default
        return MiniStatusline.combine_groups {
          { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
          '%<', -- Mark general truncate point
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          '%=', -- End left alignment
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
          { hl = mode_hl, strings = { search, location } },
        }
      end
      -- vim.api.nvim_exec2('hi! link MiniStatuslineFilename MiniLineModeNormal', {})
      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
