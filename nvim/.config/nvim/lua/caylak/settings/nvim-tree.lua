local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end
local nvim_tree_api = require("nvim-tree.api")

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
	return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

local getCustomFilter = function()
	local status_ok, plenary = pcall(require, "plenary")
	if not status_ok then
		return
	end

	local Path = require("plenary.path")
	local join = require("plenary.functional").join
	local map = require("plenary.functional").kv_map
	local content = Path:new("~/.config/nvim/ignore-patterns"):read()
	local list = vim.tbl_filter(function(line)
		return line ~= "" and line:match("^[^#]")
	end, vim.split(content, "\n", { trimempty = true }))

	local converted = map(function(kv)
		return kv[2]:gsub("^/(.*)", "^%1$"):gsub("%.", "\\."):gsub("*", ".*"):gsub("?", ".\\?")
	end, list)

	return converted
end

nvim_tree.setup({
	renderer = {
		root_folder_modifier = ":t",
		icons = {
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	view = {
		width = 30,
		side = "left",
		mappings = {
			list = {
				{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
				{ key = "h", cb = tree_cb("close_node") },
				{ key = "v", cb = tree_cb("vsplit") },
			},
		},
	},
	filters = {
		custom = getCustomFilter(),
	},
	-- project.nvim integration
	sync_root_with_cwd = true,
	respect_buf_cwd = false,
	update_focused_file = {
		enable = true,
		update_root = false,
	},
	git = {
		ignore = false,
	},
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
		},
		change_dir = {
			enable = true,
			global = false,
			restrict_above_cwd = false,
		},
	},
})

vim.api.nvim_set_keymap("n", "<F1>", "", {
	callback = function()
		nvim_tree_api.tree.toggle(true)
	end,
	noremap = true,
})
