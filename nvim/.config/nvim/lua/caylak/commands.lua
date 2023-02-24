local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')

vim.api.nvim_create_user_command("Vimrc", function()
	require("telescope.builtin").find_files({ cwd = "~/.config/nvim/lua", hidden = true })
end, {})

vim.api.nvim_create_user_command("Zshrc", function()
	require("telescope.builtin").find_files({ cwd = "~/dot-files/zsh", hidden = true })
end, {})

vim.api.nvim_create_user_command("Rg", function(opts)
	vim.api.nvim_command("silent grep " .. opts.args .. " | copen")
end, { nargs = "+" })

vim.api.nvim_create_user_command("NoAutoFormat", function(opts)
	if opts.bang == true then
		vim.b.noformat = false
	else
		vim.b.noformat = true
	end
end, { bang = true })

-- vim.api.nvim_create_user_command("Bn", function(opts)
--     local start_buf = vim.api.nvim_get_current_buf()
--     vim.
--     while true do
--         vim.api.nvim_get_current_buf
--     end
-- end, {})

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
