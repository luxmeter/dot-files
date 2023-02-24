local reload_module = require("plenary.reload").reload_module

local utils = require("caylak.utils")
local autocmd = utils.create_autocmd_proxy("default")

-- hot reload
autocmd({ "BufWritePost" }, {
	pattern = { "**/lua/caylak/*.lua" },
	callback = function(event)
		local module = string.gsub(event.file, ".-/lua/(.-).lua", "%1")
		module = string.gsub(module, "/", ".")
		vim.lsp.stop_client(vim.lsp.get_active_clients())
		vim.cmd("silent! edit")
		reload_module(module)
		vim.cmd("source $MYVIMRC")
	end,
})

autocmd({ "BufWritePost" }, {
	pattern = { os.getenv("MYVIMRC") },
	command = "source $MYVIMRC",
})

autocmd({ "TextYankPost" }, {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 250 })
	end,
})

-- spell completion
autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "gitcommit" },
	command = "setlocal spell",
})

-- removing entries in quickfix will remove line in corresponding buffer
-- autocmd({ "FileType" }, {
-- 	pattern = { "qf" },
-- 	command = "set nobuflisted | noremap <buffer> dd <cr>0d$:exec winnr('$') . \"wincmd w\"<cr>dd",
-- })

-- todo move to plugins specific config file
autocmd({ "FileType" }, {
	pattern = { "html,xml,css,javascript,typescript,typescriptreact,javascriptreact" },
	command = "EmmetInstall",
})

autocmd({ "BufWritePre" }, {
	pattern = { "*.py" },
	command = "ImpSort!",
})

autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = "%s/\\s\\+$//e",
})

autocmd({ "FileType" }, {
	pattern = { "qf", "fugitive" },
	command = "set nobuflisted",
})

autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.jenkinsfile", "Jenkinsfile" },
	command = "set ft=groovy",
})
