function! s:CompleteVirtualEnv(arg_lead, cmd_line, cursor_pos)
    return virtualenv#names(a:arg_lead)
endfunction

command! Hclose helpclose

command! -range FormatXml <line1>,<line2>!xmllint --format -
command! -range FormatStacktrace silent! <line1>,<line2>s/\\tat/	/g | silent! <line1>,<line2>s/\\n//g
command! -range FormatJson silent! <line1>,<line2>!python3 -m json.tool
command! -nargs=? -complete=customlist,s:CompleteVirtualEnv UpdatePythonPath call Update_Python_Path(<q-args>)

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
command! -range -nargs=1 Entities call HtmlEntities(<line1>, <line2>, <args>)
noremap <silent> <Leader>h :Entities 0<CR>
noremap <silent> <Leader>H :Entities 1<CR>

function! s:Underline(chars)
	let chars = empty(a:chars) ? '-' : a:chars
	let nr_columns = virtcol('$') - 1
	let uline = repeat(chars, (nr_columns / len(chars)) + 1)
	put =strpart(uline, 0, nr_columns)
endfunction
command! -nargs=? Underline call s:Underline(<q-args>)
command! Difft windo diffthis
command! Diffo windo diffoff

" follow symlinked file
function! FollowSymlink()
	let current_file = expand('%:p')
	" check if file type is a symlink
	if getftype(current_file) == 'link'
		" if it is a symlink resolve to the actual file path
		"   and open the actual file
		let actual_file = resolve(current_file)
		silent! execute 'file ' . actual_file
	end
endfunction

" set working directory to git project root
" or directory of current file if not git project
function! SetProjectRoot()
	" default to the current file's directory
	" echom 'Path: '.expand('%:p:h')
	lcd %:p:h
	let git_dir = system("git rev-parse --show-toplevel")
	" See if the command output starts with 'fatal' (if it does, not in a git repo)
	let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
	" if git project, change local directory to git project root
	if empty(is_not_git_dir)
		lcd `=git_dir`
	endif
endfunction

function! MarkdownLevel()
	let h = matchstr(getline(v:lnum), '^#\+')
	if empty(h)
		return "="
	else
		return ">" . len(h)
	endif
endfunction

function! CopyMatches(reg)
	let hits = []
	%s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
	let reg = empty(a:reg) ? '+' : a:reg
	execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

function! LC_maps()
	if has_key(g:LanguageClient_serverCommands, &filetype)
		nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
		nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
		nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
	endif
endfunction

function! Update_Python_Path(...)
	if a:0 > 0
		let name = a:1
		echom 'Activating virtual env ' .name
		execute ':VirtualEnvActivate ' .name
	endif

	let python_path = $VIRTUAL_ENV
	if len(python_path) == 0
		echom 'No VirtualEnv set'
	else
		let g:LanguageClient_serverCommands['python'] = [python_path . '/bin/pyls']
		:LanguageClientStop
		:LanguageClientStart
	endif
endfunction
