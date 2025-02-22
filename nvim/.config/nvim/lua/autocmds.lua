local autocmd = vim.api.nvim_create_autocmd

-- reload modules
autocmd("BufWritePost", {
	pattern = vim.tbl_map(function(path)
		return vim.fs.normalize(vim.loop.fs_realpath(path))
	end, vim.fn.glob(vim.fn.stdpath("config") .. "/lua/*.lua", true, true, true)),
	group = vim.api.nvim_create_augroup("Reload", {}),

	callback = function(opts)
		local fp = vim.fn.fnamemodify(vim.fs.normalize(vim.api.nvim_buf_get_name(opts.buf)), ":r") --[[@as string]]
		local app_name = vim.env.NVIM_APPNAME and vim.env.NVIM_APPNAME or "nvim"
		-- use substitute to fix issues with special chars in app_name like '-'
		local module = vim.fn.substitute(fp, "^.*/lua/", "", ""):gsub("/", ".")

		local ok, preload = pcall(require, "plenary.reload")
		if ok then
			preload.reload_module(module)
			require(module)
			print("reloaded " .. module)
		end
	end,
})
