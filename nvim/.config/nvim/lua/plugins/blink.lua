return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		{
			"nvim-tree/nvim-web-devicons",
			"onsails/lspkind.nvim",
			"L3MON4D3/LuaSnip",
			build = (function()
				-- Build Step is needed for regex support in snippets.
				-- This step is not supported in many windows environments.
				-- Remove the below condition to re-enable on windows.
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			opts = { history = true, updateevents = "TextChanged,TextChangedI" },
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
						require("luasnip.loaders.from_lua").load()
						require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })
						require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./vsnip-snippets" } })
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
		},
	},

	-- use a release tag to download pre-built binaries
	version = "*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-e: Hide menu
		-- C-k: Toggle signature help
		--
		keymap = { preset = "enter" },

		completion = {
			menu = {
				border = "single",
				draw = {
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local lspkind = require("lspkind")
								local icon = ctx.kind_icon
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon = require("lspkind").symbolic(ctx.kind, {
										mode = "symbol",
									})
								end

								return icon .. ctx.icon_gap
							end,

							-- Optionally, use the highlight groups from nvim-web-devicons
							-- You can also add the same function for `kind.highlight` if you want to
							-- keep the highlight groups in sync with the icons.
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
					},
				},
			},

			documentation = { auto_show = true, auto_show_delay_ms = 0, window = { border = "single" } },
			trigger = { show_in_snippet = false },
			list = {
				selection = {
					preselect = function()
						return not require("blink.cmp").snippet_active()
					end,
					auto_insert = true,
				},
			},
		},

		cmdline = { completion = { ghost_text = { enabled = true } } },

		appearance = {
			use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "normal",
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },

		-- Use a preset for snippets, check the snippets documentation for more information
		snippets = { preset = "luasnip" },

		-- Experimental signature help support
		signature = { enabled = true, window = { border = "single" } },
	},
	opts_extend = { "sources.default" },
}
