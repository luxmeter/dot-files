-- LSP Plugins
return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- Library paths can be absolute
				-- "~/projects/my-awesome-lib",
				-- Or relative, which means they will be resolved from the plugin dir.
				"lazy.nvim",
				"plenary.nvim",
				{ path = "snacks.nvim", words = { "snacks" } },
				-- It can also be a table with trigger words / mods
				-- Only load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				-- always load the LazyVim library
				"LazyVim",
				-- Only load the lazyvim library when the `LazyVim` global is found
				{ path = "LazyVim", words = { "LazyVim" } },
				-- Load the wezterm types when the `wezterm` module is required
				-- Needs `justinsgithub/wezterm-types` to be installed
				{ path = "wezterm-types", mods = { "wezterm" } },
				{ path = "LuaSnip", mods = { "luasnip" } },
			},
			-- always enable unless `vim.g.lazydev_enabled = false`
			-- This is the default
			-- disable when a .luarc.json file is found
			enabled = function(root_dir)
				return vim.g.lazydev_enabled == nil and true
					or vim.g.lazydev_enabled
					or vim.uv.fs_stat(root_dir .. "/.luarc.json")
			end,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			-- "hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- set keybindings and whatnot when LSP client attaches to the buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- replaced by snacks
					--  For example, in C this would take you to the header.
					-- map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					-- local ok, _ = pcall(require, "telescope.builtin")
					-- if ok then
					-- 	map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					-- 	map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					-- 	map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					-- 	map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					-- 	map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					-- 	map(
					-- 		"<leader>ws",
					-- 		require("telescope.builtin").lsp_dynamic_workspace_symbols,
					-- 		"[W]orkspace [S]ymbols"
					-- 	)
					-- end
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("<M-CR>", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.INFO] = "",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			--  NOTE: Keys are ere Mason package names!
			local servers = {
				-- python linter and formatter
				ruff = {
					on_attach = function(client, bufnr)
						if client and client.server_capabilities.hoverProvider then
							-- Disable hover in favor of Pyright
							client.server_capabilities.hoverProvider = false
						end
					end,
				},
				-- python type checker and language server
				pyright = {
					settings = {
						pyright = {
							disableOrganizeImports = true, -- Using Ruff
						},
						python = {
							analysis = {
								ignore = { "*" }, -- Using Ruff
							},
						},
					},
				},
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
				-- install rust_analyzer but don't enable it (see handlers below)
				rust_analyzer = {},

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
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							diagnostics = {
								disable = { "missing-fields" },
								globals = { "vim", "MiniStatusline", "snacks" },
							},
							hint = {
								enable = false,
								-- arrayIndex = 'Enable',
								-- setType = true,
							},
						},
					},
				},

				gdtoolkit = {},
			}

			-- Ensure the servers and tools above are installed
			--
			-- To check the current status of installed tools and/or manually install
			-- other tools, you can run
			--    :Mason
			--
			-- You can press `g?` for help in this menu.
			--
			-- `mason` had to be setup earlier: to configure its options see the
			-- `dependencies` table for `nvim-lspconfig` above.
			--
			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"shfmt",
				"shellcheck",
				-- "gdtoolkit",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
					rust_analyzer = nil,
				},
			})

			-- mason-lspconfig has no mapping for gdtoolkit to gdscript
			-- so we have to call it ourselves
			local gdscript = require("lspconfig.configs.gdscript")
			require("lspconfig").gdscript.setup(gdscript)
		end,
	},
	{
		"simrat39/rust-tools.nvim",
		event = { "BufEnter *.rs", "FileType rust" },
		enabled = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = function(_, opts)
			-- https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb
			local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.9.0/"
			local codelldb_path = extension_path .. "adapter/codelldb"
			local liblldb_path = extension_path .. "lldb/lib/liblldb"
			local this_os = vim.loop.os_uname().sysname

			-- The path in windows is different
			if this_os:find("Windows") then
				codelldb_path = extension_path .. "adapter\\codelldb.exe"
				liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
			else
				-- The liblldb extension is .so for linux and .dylib for macOS
				liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
			end

			-- lldb-vscode: brew install llvm
			local adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
			local util = require("lspconfig.util")

			local rustPorjectDir = nil -- caches current project dir
			local rustRootPattern = util.root_pattern("Cargo.toml", "rust-project.json") -- default `root_dir` implementation
			local rust_root_dir = function(fname)
				local function get()
					rustPorjectDir = rustRootPattern(fname)
					return rustPorjectDir
				end
				return rustPorjectDir or get()
			end
			return vim.tbl_deep_extend("force", opts, {
				dap = {
					adapter = adapter,
				},
				inlay_hints = {
					auto = false,
				},
				server = {
					root_dir = rust_root_dir,
					settings = {
						["rust-analyzer"] = {
							check = {
								command = "clippy",
							},
							checkOnSave = true,
							-- checkOnSave = {
							--   enable = true,
							--   command = "clippy",
							-- },
							files = {
								excludeDirs = { ".cargo", ".rustup" },
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
}
