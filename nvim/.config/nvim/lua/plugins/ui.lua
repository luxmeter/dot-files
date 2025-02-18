return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    enabled = true,
    lazy = false,
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        treesitter = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = '',
        },
        dap = {
          enabled = true,
          enable_ui = true, -- enable nvim-dap-ui
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
          },
          inlay_hints = {
            background = true,
          },
        },
        semantic_tokens = true,
        telescope = {
          enabled = true,
          -- style = "nvchad"
        },
        lsp_trouble = true,
        which_key = true,
      },
      transparent_background = false,
    },
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },
  {
    'folke/trouble.nvim',
    enabled = true,
    dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/which-key.nvim' },
      -- stylua: ignore start
        keys = {
            {'<leader>xx', function() require('trouble').toggle 'diagnostics' end,  desc = 'Workspace diagnostics' },
            {'<leader>xd', function() require('trouble').toggle 'diagnostics_buffer' end,  desc = 'Document diagnostics' },
            {'<leader>xq', function() require('trouble').toggle 'quickfix' end,  desc = 'Show Diagnostics in Quickfix' },
            {'<leader>xl', function() require('trouble').toggle 'loclist' end,  desc = 'Show Diagnostics in Loclist' },
        },
    -- stylua: ignore end
    opts = function(opts)
      vim.tbl_extend('force', opts, {
        -- icons / text used for a diagnostic
        error = ' ',
        warn = ' ',
        hint = ' ',
        information = ' ',
        other = ' ',
      })

      require('which-key').register {
        ['<leader>x'] = { name = '+diagnostics', _ = 'which_key_ignore' },
      }

      -- vim.keymap.set("n", "]d", function()
      --   require("trouble").next({ skip_groups = true, jump = true })
      -- end, { desc = "Go to previous diagnostic message" })
      -- vim.keymap.set("n", "[d", function()
      --   require("trouble").previous({ skip_groups = true, jump = true })
      -- end, { desc = "Go to next diagnostic message" })

      -- Diagnostic keymaps
      local function troubles_visible()
        local ok, trouble = pcall(require, 'trouble')
        return ok and trouble.is_open()
      end

      local function next_trouble()
        if troubles_visible() then
          require('trouble').next { skip_groups = true, jump = true }
        else
          vim.diagnostic.goto_next()
        end
      end

      local function prev_trouble()
        if troubles_visible() then
          require('trouble').prev { skip_groups = true, jump = true }
        else
          vim.diagnostic.goto_prev()
        end
      end
      vim.keymap.set('n', ']d', next_trouble, { desc = 'Previous diagnostic' })
      vim.keymap.set('n', '[d', prev_trouble, { desc = 'Next diagnostic' })
    end,
  },

  {
    'folke/noice.nvim',
    enabled = true,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      messages = {
        view = 'notify',
        view_error = 'notify',
        view_warn = 'notify',
        view_history = 'messages',
        view_search = 'virtualtext',
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },

      --  Name indicating the message kind:
      -- "" (empty)	Unknown (consider a feature-request: |bugs|)
      -- "confirm"	|confirm()| or |:confirm| dialog
      -- "confirm_sub"	|:substitute| confirm dialog |:s_c|
      -- "emsg"		Error (|errors|, internal error, |:throw|, …)
      -- "echo"		|:echo| message
      -- "echomsg"	|:echomsg| message
      -- "echoerr"	|:echoerr| message
      -- "lua_error"	Error in |:lua| code
      -- "rpc_error"	Error response from |rpcrequest()|
      -- "return_prompt"	|press-enter| prompt after a multiple messages
      -- "quickfix"	Quickfix navigation message
      -- "search_count"	Search count message ("S" flag of 'shortmess')
      -- "wmsg"		Warning ("search hit BOTTOM", |W10|, …)
      routes = {
        {
          filter = { event = 'notify', find = 'No information available' },
          opts = { skip = true },
        },
        -- quickfix: no errors
        {
          filter = { kind = 'emsg', find = 'E42' },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
        {
          view = 'mini',
          filter = { event = 'msg_showmode' },
        },
      },
      timer = { delay = 6000 },
    },
    config = function(self, opts)
      require('notify').setup()
      require('noice').setup(opts)
      vim.keymap.set({ 'n', 'i', 's' }, '<c-f>', function()
        if not require('noice.lsp').scroll(4) then
          return '<c-f>'
        end
      end, { silent = true, expr = true })

      vim.keymap.set({ 'n', 'i', 's' }, '<c-b>', function()
        if not require('noice.lsp').scroll(-4) then
          return '<c-b>'
        end
      end, { silent = true, expr = true })
    end,
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    enabled = true,
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = '▏',
        tab_char = '▏',
      },
      scope = {
        enabled = false,
      },
    },
  },
  {
    'ecthelionvi/NeoColumn.nvim',
    event = 'VeryLazy',
    opts = {
      NeoColumn = '120',
      excluded_ft = { 'text' },
    },
  },
}
