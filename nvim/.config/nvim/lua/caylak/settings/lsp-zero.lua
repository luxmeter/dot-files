local status_ok, lsp = pcall(require, "lsp-zero")
if not status_ok then
	return
end

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

lsp.preset("recommended")
lsp.ensure_installed({
	"lua_ls",
	"pyright",
	"tsserver",
	"cssls",
	"rust_analyzer",
})
lsp.nvim_workspace({
	library = vim.api.nvim_get_runtime_file("", true),
})

lsp.on_attach(function(client, buffer)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "<c-p>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("i", "<c-p>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<m-cr>", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("i", "<m-cr>", vim.lsp.buf.code_action, bufopts)
end)

lsp.setup_nvim_cmp({
	preselect = "none",
	completion = {
		completeopt = "menu,menuone,noinsert,noselect",
	},
	mapping = lsp.defaults.cmp_mappings({
		-- ["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand({})
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	}),
})
lsp.setup()
