local fn = vim.fn

-- Own plugins
if fn.isdirectory(vim.env.HOME .. "/Projects/neovim/mongojuuid") then
	vim.opt.runtimepath:append(vim.env.HOME .. "/Projects/neovim/mongojuuid")
end

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

local packer = require("packer")
packer.startup(function(use)
	-- (nvim-)lua
	use("wbthomason/packer.nvim") -- Packer can manage itself
	use({ "nvim-lua/plenary.nvim" }) -- useful lua functions
	use("svermeulen/vimpeccable")

	-- improvement user experience
	use("ahmedkhalf/project.nvim") -- project management
	use("bronson/vim-visual-star-search") -- make * search work as expectd
	use("easymotion/vim-easymotion") -- navigation
	use("godlygeek/tabular") -- align text by pattern
	use("goolord/alpha-nvim") -- start page
	use("lambdalisue/suda.vim") -- workaround for sudo-bug in neovim (:SudaWrite)
	use("lukas-reineke/indent-blankline.nvim") -- show indentation
	use("moll/vim-bbye") -- remove buffer while keeping window layout
	use("psliwka/vim-smoothie") -- smooth scrolling with ctrl+d, ctrl+e
	use("stefandtw/quickfix-reflector.vim") -- reflect changes in quickfix buffer
	use("tpope/vim-abolish") -- better substitution, e.g. :%Subvert/facilit{y,ies}/building{,s}/g
	use("tpope/vim-eunuch") -- file commands (move, delete...)
	use("tpope/vim-fugitive") -- wrapper around git cmds
	use("tpope/vim-repeat") -- make vim repeat (.) work as expected
	use("tpope/vim-scriptease") -- useful commands for vim scripting, e.g :Messages, :Vedit and such
	use("tpope/vim-sleuth") -- automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
	use("tpope/vim-surround") -- surround easily words with parenthesis and such
	use("tpope/vim-unimpaired") -- useful key-bindings for cn ([c), bn ([b) and such
	use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
	use("vim-scripts/loremipsum") -- loremipsum generator
	use("anuvyklack/pretty-fold.nvim") -- prettier folds
	use({ "michaelb/sniprun", run = "bash install.sh" })
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

	-- markdown
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})

	-- navigation
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icons
		},
	})
	use("folke/which-key.nvim")

	-- appearance
	use({
		"hoob3rt/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
	})
	use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })
	-- colorschemes
	use("EdenEast/nightfox.nvim")
	use("rakr/vim-two-firewatch")
	use("Th3Whit3Wolf/one-nvim")
	use("rafamadriz/neon")
	use("sainnhe/sonokai")
	use("tomasiser/vim-code-dark")
	use("lunarvim/darkplus.nvim")
	use("sainnhe/edge")
	use("shaunsingh/nord.nvim")
	use("sainnhe/gruvbox-material")
	use("marko-cerovac/material.nvim")
	use({ "adisen99/codeschool.nvim", requires = { "rktjmp/lush.nvim" } })
	use("folke/tokyonight.nvim")

	-- fuzzy finder
	use("nvim-telescope/telescope.nvim")

	-- lsp stuff
	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})
	use({ "jose-elias-alvarez/null-ls.nvim", requires = {
		"nvim-lua/plenary.nvim",
	} })

	use({
		"zbirenbaum/copilot.lua",
	})

	use({
		"zbirenbaum/copilot-cmp",
	})

	-- syntax highlighting and text motion
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	-- TODO configure
	-- use { 'nvim-treesitter/nvim-treesitter-textobjects' }

	-- TODO replace everything with tree-sitter
	use("google/vim-jsonnet")
	use({
		"numirias/semshi",
		run = ":UpdateRemotePlugins",
	})

	-- dev
	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})
	use("tpope/vim-commentary") -- replace with 	use({ "numToStr/Comment.nvim" })
	use("AndrewRadev/sideways.vim")

	use("towolf/vim-helm")

	-- web dev
	use("alvan/vim-closetag")
	use("mattn/emmet-vim")

	-- python dev
	use("tweekmonster/impsort.vim")
	use("Vimjas/vim-python-pep8-indent")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

local group = vim.api.nvim_create_augroup("packer", {})
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = group,
	pattern = { "plugins.lua" },
	callback = function(event)
		vim.cmd('echom "Recompiling plugins"')
		vim.cmd("source " .. event.file)
		packer.compile()
	end,
})
