require("caylak.plugins")
require("caylak.options")
require("caylak.autocmds")
require("caylak.keymaps")
require("caylak.commands")

-- plugin settings
local files = vim.api.nvim_get_runtime_file("**/caylak/settings/*.lua", true)
for _, file in ipairs(files) do
	local module = string.gsub(file, ".-/lua/(.-)%.lua", "%1")
	module = string.gsub(module, "/", ".")
	require(module)
end

-- require('caylak.settings.lsp')
