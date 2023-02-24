local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
	debug = true,
	sources = {
		formatting.yamlfmt.with({}),
		formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
		formatting.isort,
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua.with({ extra_args = { "--indent-width=2" } }),
		formatting.shfmt.with({ extra_args = { "--indent=2" } }),
		formatting.sqlformat.with({ args = { "$FILENAME" }, extra_args = { "-r", "-s" } }),
		code_actions.gitsigns,
		code_actions.shellcheck,
		diagnostics.shellcheck,
	},
})

local utils = require("caylak.utils")
local create_autocmd = utils.create_autocmd_proxy("null-ls")

local setup_formatting = function(client, bufnr)
	-- if you want to set up formatting on save, you can use this as a callback
	-- print(
	-- 	"attaching client "
	-- 		.. client.name
	-- 		.. " .. to "
	-- 		.. vim.api.nvim_buf_get_name(bufnr)
	-- 		.. ": "
	-- 		.. vim.inspect(client.supports_method("textDocument/formatting"))
	-- )
	if client.supports_method("textDocument/formatting") then
		create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				if vim.b.noformat == true or tonumber(vim.b.noformat) == 1 then
					return
				end
				vim.lsp.buf.format({
					filter = function(client)
						-- apply whatever logic you want (in this example, we'll only use null-ls)
						return client.name == "null-ls"
					end,
					bufnr = bufnr,
				})
			end,
		})
	end
end

create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- looks like it doesn't work
		setup_formatting(client, bufnr)
	end,
})
