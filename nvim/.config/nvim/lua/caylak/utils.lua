local map = function(mode, lhs, rhs, opts)
	local _opts = vim.tbl_deep_extend("force", { noremap = true }, opts or {})
	vim.keymap.set(mode, lhs, rhs, _opts)
end

local nmap = function(lhs, rhs, opts)
	map("n", lhs, rhs, opts)
end

local imap = function(lhs, rhs, opts)
	map("i", lhs, rhs, opts)
end

local vmap = function(lhs, rhs, opts)
	map("x", lhs, rhs, opts)
end

local xmap = function(lhs, rhs, opts)
	map("x", lhs, rhs, opts)
end

local tmap = function(lhs, rhs, opts)
	map("t", lhs, rhs, opts)
end

local function create_autocmd_proxy(group)
	local group = vim.api.nvim_create_augroup(group, {})
	return function(events, opts)
		local _opts = vim.tbl_deep_extend("force", {
			group = group,
		}, opts or {})
		vim.api.nvim_create_autocmd(events, _opts)
	end
end

return {
	nmap = nmap,
	imap = imap,
	vmap = vmap,
	xmap = xmap,
	tmap = tmap,
	create_autocmd_proxy = create_autocmd_proxy,
}
