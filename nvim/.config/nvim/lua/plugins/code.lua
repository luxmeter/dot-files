return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    enabled = true,
    dependencies = {
      'folke/which-key.nvim',
      'nvim-telescope/telescope.nvim',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'SmiteshP/nvim-navic',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- Library paths can be absolute
            -- "~/projects/my-awesome-lib",
            -- Or relative, which means they will be resolved from the plugin dir.
            'lazy.nvim',
            'plenary.nvim',
            -- It can also be a table with trigger words / mods
            -- Only load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            -- always load the LazyVim library
            'LazyVim',
            -- Only load the lazyvim library when the `LazyVim` global is found
            { path = 'LazyVim', words = { 'LazyVim' } },
            -- Load the wezterm types when the `wezterm` module is required
            -- Needs `justinsgithub/wezterm-types` to be installed
            { path = 'wezterm-types', mods = { 'wezterm' } },
          },
          -- always enable unless `vim.g.lazydev_enabled = false`
          -- This is the default
          -- disable when a .luarc.json file is found
          enabled = function(root_dir)
            return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled or vim.uv.fs_stat(root_dir .. '/.luarc.json')
          end,
        },
      },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          local imap = function(keys, func, desc)
            vim.keymap.set('i', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('gD', require('telescope.builtin').lsp_type_definitions, '[G]oto Type')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<space>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd')
          map('<space>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove')
          map('<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, 'Workspace [L]ist')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('<M-CR>', vim.lsp.buf.code_action, 'Code Action')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          imap('<C-K>', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          require('which-key').register {
            ['<leader>c'] = { name = '+code', _ = 'which_key_ignore' },
          }

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- perf killer?
          if client and client.server_capabilities.documentSymbolProvider then
            require('nvim-navic').attach(client, event.buf)
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      -- from https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/lspconfig.lua
      capabilities = vim.tbl_deep_extend('force', capabilities, {
        documentationFormat = { 'markdown', 'plaintext' },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
          },
        },
      })

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        ruff = {},
        pyright = {
          settings = {
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { '*' },
              },
            },
          },
        },

        rust_analyzer = {},

        gopls = {
          on_attach = function(client, bufnr)
            if client and client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable()
              -- vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = 'red' })
            end
          end,

          settings = {
            gopls = {
              -- buildFlags = { '-mod=vendor' },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = true,
              },
            },
          },
        },

        lua_ls = {
          settings = {
            Lua = {
              -- workspace = {
              --   library = {
              --     [vim.api.nvim_get_runtime_file('', true)] = true,
              --     [vim.env.HOME .. '/.local/share/nvim/lazy/telescope.nvim'] = true,
              --     ['./lua'] = true,
              --   },
              -- },
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' }, globals = { 'vim', 'MiniStatusline' } },
              hint = {
                enable = false,
                -- arrayIndex = 'Enable',
                -- setType = true,
              },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'shfmt',
        'shellcheck',
        'gdtoolkit',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          rust_analyzer = nil,
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      local gdscript = require 'lspconfig.configs.gdscript'
      require('lspconfig').gdscript.setup(gdscript)
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    event = { 'BufEnter *.rs', 'FileType rust' },
    enabled = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
    },
    opts = function(_, opts)
      -- https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb
      local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.9.0/'
      local codelldb_path = extension_path .. 'adapter/codelldb'
      local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib' -- MacOS: This may be .dylib

      -- lldb-vscode: brew install llvm
      local adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
      local util = require 'lspconfig.util'

      local rustPorjectDir = nil -- caches current project dir
      local rustRootPattern = util.root_pattern('Cargo.toml', 'rust-project.json') -- default `root_dir` implementation
      local rust_root_dir = function(fname)
        local function get()
          rustPorjectDir = rustRootPattern(fname)
          return rustPorjectDir
        end
        return rustPorjectDir or get()
      end
      return vim.tbl_deep_extend('force', opts, {
        dap = {
          adapter = adapter,
        },
        inlay_hints = {
          auto = false,
        },
        server = {
          root_dir = rust_root_dir,
          settings = {
            ['rust-analyzer'] = {
              check = {
                command = 'clippy',
              },
              checkOnSave = true,
              -- checkOnSave = {
              --   enable = true,
              --   command = "clippy",
              -- },
              files = {
                excludeDirs = { '.cargo', '.rustup' },
              },
              -- diagnostics = { disabled = { 'unresolved-proc-macro' } },
              diagnostics = {
                enable = true,
              },
            },
          },
        },
      })
    end,
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    enabled = true,
    event = 'InsertEnter',
    dependencies = {
      {
        -- {
        --   'zbirenbaum/copilot-cmp',
        --   dependencies = {
        --     'zbirenbaum/copilot.lua',
        --     cmd = 'Copilot',
        --     build = ':Copilot auth',
        --     opts = {
        --       suggestion = { enabled = false },
        --       panel = { enabled = false },
        --     },
        --   },
        --   event = 'InsertEnter',
        --   config = function()
        --     require('copilot_cmp').setup()
        --   end,
        -- },
        {
          -- snippet plugin
          'L3MON4D3/LuaSnip',
          build = (function()
            if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
              return
            end
            return 'make install_jsregexp'
          end)(),
          dependencies = 'rafamadriz/friendly-snippets',
          opts = { history = true, updateevents = 'TextChanged,TextChangedI' },
          config = function()
            require('luasnip.loaders.from_lua').load()
            require('luasnip.loaders.from_lua').lazy_load { paths = vim.g.lua_snippets_path or '' }
            require('luasnip.loaders.from_vscode').lazy_load { paths = { './vsnip-snippets' } }
            require('luasnip.loaders.from_vscode').lazy_load()
            -- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/configs/luasnip.lua
            vim.api.nvim_create_autocmd('InsertLeave', {
              callback = function()
                if require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()] and not require('luasnip').session.jump_active then
                  require('luasnip').unlink_current()
                end
              end,
            })
          end,
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'onsails/lspkind.nvim', -- icons
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        formatting = {
          format = require('lspkind').cmp_format {
            mode = 'text_symbol', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
            symbol_map = { Copilot = '' },
          },
        },
        window = {
          completion = cmp.config.window.bordered {
            side_padding = 1,
            scrollbar = false,
          },
          documentation = cmp.config.window.bordered(),
        },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
              cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Close
          ['<C-e>'] = cmp.mapping.close(),

          -- Accept  the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          --  Default: <C-y> ([y]yes)
          ['<CR>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-j>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-k>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          -- { name = 'copilot' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        },
      }
    end,
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    enabled = true,
    opts = {

      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.b.autoformat ~= nil and not vim.b.autoformat then
          print 'autoformat is disabled'
          return nil
        end
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Use a sub-list to run only the first available formatter
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        rust = nil,
        sh = { 'shfmt' },
        go = { 'gofmt' },
        gdscript = { 'gdformat' },
      },
      formatters = {
        shfmt = {
          prepend_args = { '-i', '4' },
        },
      },
    },
  },
  { -- Linting
    'mfussenegger/nvim-lint',
    enabled = true,
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        -- markdown = { 'markdownlint' },
        sh = { 'shellcheck' },
        zsh = { 'zsh' },
        gdscript = { 'gdlint' },
        -- python = { 'ruff' }, -- use lsp instead
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    enabled = true,
    build = ':TSUpdate',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require 'nvim-treesitter.textobjects.move' ---@type table<string,fun(...)>
          local configs = require 'nvim-treesitter.configs'
          for name, fn in pairs(move) do
            if name:find 'goto' == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module('textobjects.move')[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find '[%]%[][cC]' then
                      vim.cmd('normal! ' .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
      {
        'nvim-treesitter/nvim-treesitter-context',
        enabled = false, -- too much context, unable to filter to fucntion only
        opt = {
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
          min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
          line_numbers = true,
          multiline_threshold = 1, -- Maximum number of lines to show for a single context
          trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
          mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
          -- Separator between context and content. Should be a single character string, like '-'.
          -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
          separator = nil,
          zindex = 20, -- The Z-index of the context window
          on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
        },
      },
    },
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
          goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
          goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
        },
        select = {
          enable = true,

          -- Automatically jump forward to textobjects, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            -- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
            ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
          },
          -- You can choose the select mode (default is charwise 'v')
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`. Can also be a function (see above).
          include_surrounding_whitespace = true,
        },
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
  {
    'ldelossa/litee-calltree.nvim',
    enabled = true,
    dependencies = 'ldelossa/litee.nvim',
    config = function()
      print 'config'
      require('litee.lib').setup {
        panel = {
          orientation = 'bottom',
          panel_size = 10,
        },
      }
      require('litee.calltree').setup {
        keymaps = {
          expand = 'o',
          collapse = 'c',
          collapse_all = 'zM',
          jump = '<CR>',
          jump_split = 's',
          jump_vsplit = 'v',
          jump_tab = 't',
          hover = 'i',
          details = 'd',
          close = 'X',
          close_panel_pop_out = '<Esc>',
          help = '?',
          hide = 'H',
          switch = 'S',
          focus = 'f',
        },
      }

      vim.keymap.set('n', 'gR', function()
        vim.lsp.buf.incoming_calls()
      end, { desc = 'LSP: [G]o to [R]eference hierarchy' })
    end,
  },
  {
    'b0o/incline.nvim',
    enabled = true,
    event = 'VeryLazy',
    dependencies = {
      'SmiteshP/nvim-navic', --  might cause perf issues
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local helpers = require 'incline.helpers'
      local navic = require 'nvim-navic'
      local devicons = require 'nvim-web-devicons'
      require('incline').setup {
        window = {
          padding = 0,
          margin = { vertical = 0, horizontal = 1 },
          placement = {
            vertical = 'top',
            horizontal = 'right',
          },
        },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local res = {
            ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
            ' ',
            { filename, gui = modified and 'bold,italic' or 'bold' },
            guibg = '#44406e',
          }
          if props.focused then
            for _, item in ipairs(navic.get_data(props.buf) or {}) do
              table.insert(res, {
                { ' > ', group = 'NavicSeparator' },
                { item.icon, group = 'NavicIcons' .. item.type },
                { item.name, group = 'NavicText' },
              })
            end
          end
          table.insert(res, ' ')
          return res
        end,
      }
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    enabled = true,
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = true, auto_trigger = true, keymap = {
        accept = '<m-l>',
      } },
      panel = { enabled = true },
    },
  },

  {
    'michaelb/sniprun',
    branch = 'master',

    build = 'sh install.sh',
    -- do 'sh install.sh 1' if you want to force compile locally
    -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

    config = function()
      require('sniprun').setup {
        -- your options
        display = { 'NvimNotify' },
      }
    end,
  },
}
