local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local transform_mod = require("telescope.actions.mt").transform_mod

-- https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1227591722
local function multiopen(prompt_bufnr, method)
	local edit_file_cmd_map = {
		vertical = "vsplit",
		horizontal = "split",
		tab = "tabedit",
		default = "edit",
	}
	local edit_buf_cmd_map = {
		vertical = "vert sbuffer",
		horizontal = "sbuffer",
		tab = "tab sbuffer",
		default = "buffer",
	}
	local picker = action_state.get_current_picker(prompt_bufnr)
	local multi_selection = picker:get_multi_selection()

	if #multi_selection > 1 then
		require("telescope.pickers").on_close_prompt(prompt_bufnr)
		pcall(vim.api.nvim_set_current_win, picker.original_win_id)

		for i, entry in ipairs(multi_selection) do
			local filename, row, col

			if entry.path or entry.filename then
				filename = entry.path or entry.filename

				row = entry.row or entry.lnum
				col = vim.F.if_nil(entry.col, 1)
			elseif not entry.bufnr then
				local value = entry.value
				if not value then
					return
				end

				if type(value) == "table" then
					value = entry.display
				end

				local sections = vim.split(value, ":")

				filename = sections[1]
				row = tonumber(sections[2])
				col = tonumber(sections[3])
			end

			local entry_bufnr = entry.bufnr

			if entry_bufnr then
				if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
					vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
				end
				local command = i == 1 and "buffer" or edit_buf_cmd_map[method]
				pcall(vim.cmd, string.format("%s %s", command, vim.api.nvim_buf_get_name(entry_bufnr)))
			else
				local command = i == 1 and "edit" or edit_file_cmd_map[method]
				if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
					filename = require("plenary.path"):new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
					pcall(vim.cmd, string.format("%s %s", command, filename))
				end
			end

			if row and col then
				pcall(vim.api.nvim_win_set_cursor, 0, { row, col - 1 })
			end
		end
	else
		actions["select_" .. method](prompt_bufnr)
	end
end

local custom_actions = transform_mod({
	multi_selection_open_vertical = function(prompt_bufnr)
		multiopen(prompt_bufnr, "vertical")
	end,
	multi_selection_open_horizontal = function(prompt_bufnr)
		multiopen(prompt_bufnr, "horizontal")
	end,
	multi_selection_open_tab = function(prompt_bufnr)
		multiopen(prompt_bufnr, "tab")
	end,
	multi_selection_open = function(prompt_bufnr)
		multiopen(prompt_bufnr, "default")
	end,
})

local function stopinsert(callback)
	return function(prompt_bufnr)
		vim.cmd.stopinsert()
		vim.schedule(function()
			callback(prompt_bufnr)
		end)
	end
end

telescope.setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--no-ignore-global",
			"--ignore-file",
			vim.env.HOME .. "/.config/nvim/ignore-patterns",
		},

		prompt_prefix = " ",
		selection_caret = " ",

		mappings = {
			i = {
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,

				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				["<C-c>"] = actions.close,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,

				-- ["<CR>"] = actions.select_default,
				["<CR>"] = custom_actions.multi_selection_open,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-s>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
				["<C-l>"] = actions.complete_tag,
				["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
			},

			n = {
				["<esc>"] = actions.close,
				["<CR>"] = custom_actions.multi_selection_open,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["H"] = actions.move_to_top,
				["M"] = actions.move_to_middle,
				["L"] = actions.move_to_bottom,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,
				["gg"] = actions.move_to_top,
				["G"] = actions.move_to_bottom,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["?"] = actions.which_key,
			},
		},
	},
	pickers = {
		-- Default configuration for builtin pickers goes here:
		-- picker_name = {
		--   picker_config_key = value,
		--   ...
		-- }
		-- Now the picker_config_key will be applied every time you call this
		-- builtin picker
	},
	extensions = {
		-- Your extension configuration goes here:
		-- extension_name = {
		--   extension_config_key = value,
		-- }
		-- please take a look at the readme of the extension you want to configure
	},
})
