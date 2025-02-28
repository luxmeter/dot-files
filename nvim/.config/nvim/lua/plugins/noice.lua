return {
	"folke/noice.nvim",
	enabled = true,
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		messages = {
			view = "notify",
			view_error = "notify",
			view_warn = "notify",
			view_history = "messages",
			view_search = "virtualtext",
		},
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
			},
			signature = {
				enabled = false,
				auto_open = { enabled = false },
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
				filter = { event = "notify", find = "No information available" },
				opts = { skip = true },
			},
			-- quickfix: no errors
			{
				filter = { kind = "emsg", find = "E42" },
				opts = { skip = true },
			},
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
					},
				},
				view = "mini",
			},
			{
				view = "mini",
				filter = { event = "msg_showmode" },
			},
		},
		timer = { delay = 6000 },
	},
	config = function(self, opts)
		require("notify").setup()
		require("noice").setup(opts)
		vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
			if not require("noice.lsp").scroll(4) then
				return "<c-f>"
			end
		end, { silent = true, expr = true })

		vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
			if not require("noice.lsp").scroll(-4) then
				return "<c-b>"
			end
		end, { silent = true, expr = true })
	end,
}
