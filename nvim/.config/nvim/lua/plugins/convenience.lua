return {
	{
		-- improvement user experience
		"mbbill/undotree",
		enabled = true,
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle undotree" },
		},
	}, -- undotree
	{ "bronson/vim-visual-star-search", enabled = true }, -- make * search work as expectd
	{ "godlygeek/tabular", enabled = true, cmd = { "Tabularize" } }, -- align text by pattern
	{ "lambdalisue/suda.vim", enabled = true, cmd = { "SudaWrite", "SudaRead" } }, -- workaround for sudo-bug in neovim (:SudaWrite,
	{ "stefandtw/quickfix-reflector.vim", enabled = true }, -- reflect changes in quickfix buffer
	{ "tpope/vim-abolish", enabled = true }, -- better substitution, e.g. :%Subvert/facilit{y,ies}/building{,s}/g
	{ "tpope/vim-eunuch", enabled = true }, -- file commands (move, delete...,
	-- {'tpope/vim-repeat'}, -- make vim repeat (., work as expected
	{ -- automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file -> startup performance killer for large files
		"tpope/vim-sleuth",
		config = function()
			-- big files are mostly log files so don't apply heuristics for the sake of performance
			vim.g.sleuth_text_heuristics = 0
		end,
	},
	{ "tpope/vim-fugitive", enabled = true },
	{ "tpope/vim-rhubarb", enabled = false },
	{ "vim-scripts/loremipsum", enabled = true }, -- loremipsum generator
	{ "anuvyklack/pretty-fold.nvim", enabled = true }, -- prettier folds
	{
		"tversteeg/registers.nvim", -- view registers
		name = "registers",
		enabled = true,
		keys = {
			{ '"', mode = { "n", "v" } },
			{ "<C-R>", mode = "i" },
		},
		cmd = "Registers",
		opts = {},
	},
	{
		"nvim-pack/nvim-spectre",
		enabled = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		cmd = { "Spectre" },
	}, -- find & replace in project

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		enabled = true,
		event = { "VeryLazy" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
