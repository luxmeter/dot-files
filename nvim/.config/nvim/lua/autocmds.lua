local autocmd = vim.api.nvim_create_autocmd

local function is_large_file(event)
	local ok, size = pcall(vim.fn.getfsize, vim.api.nvim_buf_get_name(event.buf))
	return not ok or size > 1024
end

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

-- fucking slow on large files
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- no folding if buffer is bigger then 1 mb
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1100
vim.api.nvim_create_autocmd("BufReadPre", {
	group = vim.api.nvim_create_augroup("disable_folding", { clear = true }),
	callback = function(event)
		if is_large_file(event) then
			-- fallback to default values
			vim.opt.foldmethod = "manual"
			vim.opt.foldexpr = "0"
			vim.opt.foldlevel = 0
			vim.opt.foldtext = "foldtext()"
		else
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.opt.foldlevel = 99
			vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
		end
	end,
})

local function create_autocmd_proxy(group)
	local group = vim.api.nvim_create_augroup(group, {})
	return function(events, opts)
		local _opts = vim.tbl_deep_extend("force", {
			group = group,
		}, opts or {})
		vim.api.nvim_create_autocmd(events, _opts)
	end
end

autocmd = create_autocmd_proxy("default")

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
-- autocmd({ 'FileType' }, {
--   pattern = { 'html,xml,css,javascript,typescript,typescriptreact,javascriptreact' },
--   command = 'EmmetInstall',
-- })

-- autocmd({ "BufWritePre" }, {
--   pattern = { "*.py" },
--   command = "ImpSort!",
-- })

autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function(event)
		if not is_large_file(event) then
			vim.cmd("%s/\\s\\+$//e")
		end
	end,
})

autocmd({ "FileType" }, {
	pattern = { "qf", "fugitive" },
	command = "set nobuflisted",
})

autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.jenkinsfile", "Jenkinsfile" },
	command = "set ft=groovy",
})

autocmd({ "BufRead" }, {
	pattern = { "**/vendor/*", "**/node_modules/*", "**/dist/*", "**/build/*" },
	callback = function(ev)
		-- ev={
		--   buf = 453,
		--   event = "BufReadPost",
		--   file = "/Users/caylak/Projects/adobe/cpx/invitations/vendor/git.corp.adobe.com/CPX/external-config/config/invitationsConfig.go",
		--   group = 66,
		--   id = 473,
		--   match = "/Users/caylak/Projects/adobe/cpx/invitations/vendor/git.corp.adobe.com/CPX/external-config/config/invitationsConfig.go"
		-- }
		-- vendor/git.corp.adobe.com/Stormcloud/collab-base/v28/pipeline/consumer.go
		local root_patterns = { ".git", ".clang-format", "pyproject.toml", "setup.py", "node_modules", "vendor" }
		local root_dir = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
		-- expand ev.file to absolute path
		local filepath = vim.fn.fnamemodify(ev.file, ":p")
		if vim.startswith(filepath, root_dir) then
			vim.bo.readonly = true
			vim.bo.modifiable = false
		end
	end,
})

vim.api.nvim_create_user_command("LintInfo", function()
	local filetype = vim.bo.filetype
	local linters = require("lint").linters_by_ft[filetype]

	if linters then
		print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
	else
		print("No linters configured for filetype: " .. filetype)
	end
end, {})

vim.api.nvim_create_user_command("Edit", function(opts)
	require("telescope.builtin").find_files({
		prompt_title = "Edit Files",
		-- expand ~ to $HOME
		cwd = vim.fn.expand(opts.args),
		find_command = { "rg", "--files", "--one-file-system", "--color", "never", "--sortr", "created" },
	})
end, { nargs = 1, complete = "dir" })

vim.api.nvim_create_user_command("DiffFormat", function()
	local ok, gs = pcall(require, "gitsigns")
	if not ok then
		return
	end

	local ok, c = pcall(require, "conform")
	if not ok then
		return
	end

	for _, hunk in ipairs(gs.get_hunks()) do
		-- {
		--   added = {
		--     count = 0,
		--     lines = {},
		--     start = 0
		--   },
		--   head = "@@ -1,6 +0 @@",
		--   lines = { '-local handler = vim.lsp.handlers["callHierarchy/incomingCalls"]', '-vim.lsp.handlers["callHierarchy/incomingCalls"] = function(err, result, ctx, config)', "-  handler(err, result, ctx, config)", '-  print("result=" .. vim.inspect(result))', "-end", "-" },
		--   removed = {
		--     count = 6,
		--     lines = { 'local handler = vim.lsp.handlers["callHierarchy/incomingCalls"]', 'vim.lsp.handlers["callHierarchy/incomingCalls"] = function(err, result, ctx, config)', "  handler(err, result, ctx, config)", '  print("result=" .. vim.inspect(result))', "end", "" },
		--     start = 1
		--   },
		--   type = "delete"
		-- },
		-- {
		--     added = {
		--       count = 1,
		--       lines = { 'vim.api.nvim_create_user_command("OpenInGithub", function(opts)' },
		--       start = 187
		--     },
		--     head = "@@ -144,1 +187,1 @@",
		--     lines = { '-vim.api.nvim_create_user_command("GithubOpen", function(opts)', '+vim.api.nvim_create_user_command("OpenInGithub", function(opts)' },
		--     removed = {
		--       count = 1,
		--       lines = { 'vim.api.nvim_create_user_command("GithubOpen", function(opts)' },
		--       start = 144
		--     },
		--     type = "change"
		--   }
		if hunk.type ~= "delete" then
			local range = {
				start = { hunk.added.start, 0 },
				["end"] = { hunk.added.start + #hunk.added.lines + 1, 0 },
			}
			-- print("range: ", vim.inspect(range))
			local result = c.format({
				range = range,
			})
			-- print("formatted=", result)
		end
	end
end, {})

-- [[ Highlight on yank ]]
local highlight_group = create_autocmd_proxy("YankHighlight")
highlight_group({ "TextYankPost" }, {
	pattern = { "*" },
	command = 'silent! lua vim.highlight.on_yank {higroup="Visual", timeout=150}',
})

--- cmmands
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')

vim.api.nvim_create_user_command("RustCleanImport", function()
	local i = require("plenary.iterators")
	-- vim.lsp.rust_analyzer.1
	local namespaces = vim.api.nvim_get_namespaces()
	local _, id = i.iter(namespaces):find(function(name)
		return vim.startswith(name, "vim.lsp.rust_analyzer")
	end)

	local diags = vim.diagnostic.get(0, { namespace = id })

	if id ~= nil then
		for _, diag in ipairs(diags) do
			if diag.namespace == id and diag.code == "unused_imports" then
				if diag.col > 0 then
					vim.lsp.buf.code_action({
						filter = function(code_action)
							if code_action.isPreferred then
								return code_action.isPreferred
							end
							return true
						end,
						context = { only = { "quickfix" } },
						apply = true,
						range = {
							start = { diag.lnum + 1, diag.col },
							["end"] = { diag.end_lnum + 1, diag.end_col },
						},
					})
				end
			end
		end
	end
end, {})

vim.api.nvim_create_user_command("Reveal", function()
	require("neo-tree.command").execute({ action = "focus", reveal_file = vim.fn.expand("%:p") })
end, {})

vim.api.nvim_create_user_command("OpenCwd", function()
	vim.api.nvim_command("!open " .. vim.fn.getcwd())
end, {})

vim.api.nvim_create_user_command("OpenInFinder", function()
	local reveal_file = vim.fn.expand("%:p:h")
	if reveal_file == "" then
		reveal_file = vim.fn.getcwd()
	else
		if vim.fn.isdirectory(reveal_file) == false then
			reveal_file = vim.fn.getcwd()
		end
	end
	vim.api.nvim_command("!open " .. reveal_file)
end, {})

vim.api.nvim_create_user_command("OpenCwd", function()
	vim.api.nvim_command("!open " .. vim.fn.getcwd())
end, {})

vim.api.nvim_create_user_command("SearchFunction", function()
	require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Function", "Method" } })
end, {})

vim.api.nvim_create_user_command("Commands", function()
	require("telescope.builtin").commands()
end, {})

vim.api.nvim_create_user_command("Vimrc", function()
	require("telescope.builtin").find_files({ cwd = "~/.config/nvim/", hidden = false })
end, {})

vim.api.nvim_create_user_command("Zshrc", function()
	require("telescope.builtin").find_files({ cwd = "~/dot-files/zsh", hidden = true })
end, {})

vim.api.nvim_create_user_command("Rg", function(opts)
	vim.api.nvim_command("silent grep " .. opts.args .. " | copen")
end, { nargs = "+" })

vim.api.nvim_create_user_command("NoAutoFormat", function(opts)
	-- compatible with lazyvim
	if opts.bang == true then
		vim.b.autoformat = true
	else
		vim.b.autoformat = false
	end
end, { bang = true })

vim.api.nvim_create_user_command("OpenInGithub", function(opts)
	local Job = require("plenary.job")
	local path = vim.fn.expand("%:p")

	local job = Job:new({
		command = "git",
		args = { "rev-parse", "--show-toplevel" },
		cwd = vim.fn.expand("%:p:h"),
	})
	job:sync()
	local root = job:result()[1]
	local relative_path = vim.fn.substitute(path, root, "", "")
	vim.api.nvim_cmd({
		cmd = "!",
		args = {
			vim.env.SHELL,
			"-c",
			string.format("'cd \"%%:p:h\" && gh browse -c %s:%s-%s'", relative_path, opts.line1, opts.line2),
		},
		-- args = { "gh", "browse", "-c", string.format("%%:%s-%s", opts.line1, opts.line2) },
		magic = { file = true },
	}, {})
end, { force = true, desc = "Open in Github", range = true })

cmd("command! -nargs=* Wrap set wrap linebreak nolist")

cmd("command! Hclose helpclose")

-- Dicommand! ff commands {{{
cmd("command! Difft windo diffthis")
cmd("command! Diffo windo diffoff")
-- }}}

-- Format commands {{{
cmd("command! -range FormatXml <line1>,<line2>!xmllint --format -")
cmd("command! -range FormatStacktrace silent! <line1>,<line2>s/\\\\tat/	/g | silent! <line1>,<line2>s/\\\\n/\\n/g")
cmd("command! -range FormatJson silent! <line1>,<line2>!python3 -m json.tool")
-- }}}

-- Format Mongo Query {{{
cmd(
	'command! -range FormatMongoQuery <line1>,<line2>s/{"$binary": {"base64": \\(.\\{-}\\), "subtype": "03"}}/BinData(3, \\1)/ge | %!prettier --stdin --parser typescript'
)
-- }}}

cmd([[
" HtmlEntities {{{
" Escape/unescape & < > HTML entities in range (default current line).
function! HtmlEntities(line1, line2, action)
    let search = @/
    let range = 'silent ' . a:line1 . ',' . a:line2
    if a:action == 0  " must convert &amp; last
        execute range . 'sno/&lt;/</eg'
        execute range . 'sno/&gt;/>/eg'
        execute range . 'sno/&amp;/&/eg'
    else              " must convert & first
        execute range . 'sno/&/&amp;/eg'
        execute range . 'sno/</&lt;/eg'
        execute range . 'sno/>/&gt;/eg'
    endif
    nohl
    let @/ = search
endfunction
command! -range -nargs=1 HtmlEntities call HtmlEntities(<line1>, <line2>, <args>)
" }}}
]])
