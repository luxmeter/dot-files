command! Hclose helpclose

command! -range FormatXml <line1>,<line2>!xmllint --format -
command! -range FormatStacktrace silent! <line1>,<line2>s/\\tat/	/g | silent! <line1>,<line2>s/\\n//g
command! -range FormatJson silent! <line1>,<line2>!python3 -m json.tool

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
