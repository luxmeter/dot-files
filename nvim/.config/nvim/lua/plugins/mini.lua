return { -- Collection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	event = { "VeryLazy" },
	enabled = true,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [']quote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()
		require("mini.comment").setup()
		require("mini.move").setup()
		require("mini.pairs").setup()
		require("mini.splitjoin").setup()
		require("mini.trailspace").setup()

		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			group = vim.api.nvim_create_augroup("mini-trim", { clear = false }),
			pattern = { "*" },
			callback = function()
				require("mini.trailspace").trim()
			end,
		})

		-- Simple and easy statusline.
		--  You could remove this setup call if you don't like it,
		--  and try some other statusline plugin
		local statusline = require("mini.statusline")
		-- set use_icons to true if you have a Nerd Font
		statusline.setup({ use_icons = true })

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
			return "%2l:%-2v"
		end

		statusline.active = function()
			local _, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			local git = MiniStatusline.section_git({ trunc_width = 75 })
			local diagnostics = MiniStatusline.section_diagnostics({
				trunc_width = 75,
				icon = " ",
			})
			local filename = MiniStatusline.section_filename({ trunc_width = 140 })
			local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
			local location = MiniStatusline.section_location({ trunc_width = 75 })
			-- without recompute search lags significantly in large files
			local search = MiniStatusline.section_searchcount({ trunc_width = 75, options = { recompute = false } })
			-- default
			return MiniStatusline.combine_groups({
				{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
				"%<", -- Mark general truncate point
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=", -- End left alignment
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end
		-- vim.api.nvim_exec2('hi! link MiniStatuslineFilename MiniLineModeNormal', {})
		-- ... and there is more!
		--  Check out: https://github.com/echasnovski/mini.nvim
	end,
}
