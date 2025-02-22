local plugins = vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugins/**/*.lua", true, true, true)

local modules = {}
for _, plugin in ipairs(plugins) do
	local module = vim.fn.substitute(plugin, "^.*/lua/", "", ""):gsub("/", "."):gsub("%.lua$", "")
	-- print("loading plugin", module)
	table.insert(modules, require(module))
end

require("lazy").setup(modules, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
