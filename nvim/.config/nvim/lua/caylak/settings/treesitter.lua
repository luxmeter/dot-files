local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
	return
end

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
	ensure_installed = {
		"lua",
		"python",
		"javascript",
		"typescript",
		"json",
		"java",
		"kotlin",
		"go",
		"yaml",
		"vim",
		"tsx",
		"sql",
		"markdown",
		"make",
		"html",
		"bash",
		"dockerfile",
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	auto_install = true,

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})

local autocmd = require("caylak.utils").create_autocmd_proxy("treesitter")
autocmd({ "FileType" }, {
	pattern = "*",
	callback = function(args)
		local parsers = require("nvim-treesitter.parsers")
		local lang = parsers.get_buf_lang()
		local parser_exists = parsers.has_parser(lang)
		if not parser_exists or args.match ~= "helm" then
			return
		end
		vim.api.nvim_set_option_value("foldmethod", "expr", { scope = "local" })
		vim.api.nvim_set_option_value("foldexpr", "nvim_treesitter#foldexpr()", { scope = "local" })
	end,
})
