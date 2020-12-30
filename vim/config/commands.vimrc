command! Hclose helpclose

" Diff commands {{{
command! Difft windo diffthis
command! Diffo windo diffoff
" }}}

" FollowSymLink {{{
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
" }}}

" Format commands {{{
command! -range FormatXml <line1>,<line2>!xmllint --format -
command! -range FormatStacktrace silent! <line1>,<line2>s/\\tat/	/g | silent! <line1>,<line2>s/\\n//g
command! -range FormatJson silent! <line1>,<line2>!python3 -m json.tool
" }}}

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

" RunFile {{{
function! RunFile()
    let l:file = escape(escape(expand("%"), ' '), '\ ')
    let l:wd = escape(escape(expand("%:p:h"), ' '), '\ ')
    if &filetype =~ "typescript"
        " execute('!cd '.l:wd.' && npx tsc --build '.l:wd.' &&  node '.substitute(l:file, ".tsx", ".js", ""))
        execute('AsyncRun -save -raw -strip -cwd=<root> ts-node '.l:file)
    elseif &filetype =~ "python"
        execute('AsyncRun -save -raw -strip python '.l:file)
    else
        echom "RunFile: No routine for filetype ". &filetype ." found"
    endif
endfunction
" }}}

" Text Modifications {{{
" modify selected text using combining diacritics
command! -range -nargs=0 Overline        call s:CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call s:CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call s:CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call s:CombineSelection(<line1>, <line2>, '0336')

function! s:CombineSelection(line1, line2, cp)
    execute 'let char = "\u'.a:cp.'"'
    execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction
" }}}

" Vimrc {{{
" Likewise, Files command with preview window
command! -bang -nargs=? Vimrc
      \ call fzf#run(fzf#wrap({
        \'dir': $DOT_FILES.'/vim/config',
        \'sink': 'e',
        \}))
" }}}

command! -range -nargs=0 MapToJUUID call s:MapToJUUID(<line1>, <line2>)
function! s:MapToJUUID(line1, line2)
    let a_save = @a
    normal! gv"ay
    let content = substitute(@a, '"', '\\"', "g")
    let content = substitute(content, "'", "\\'", "g")
    let uuid = system('mongo --quiet --eval "load(''/Users/caylak/Projects/sharedcloud/mongo-scripts/migration/migrate_acp_pathtype/uuidhelpers.js''); '.content.'.toJUUID()"')
    let @a = a_save
    put =uuid
endfunction

" close netrw buffer (bug) {{{
" if it does not work try `set g:netrw_fastbrowse=0`
function! QuitNetrw()
  " echom "called QuitNetrw"
  for i in range(1, bufnr("$"))
    if buflisted(i)
    " echom "Buffer exists: ".i.", filetype is:".getbufvar(i, '&filetype')
      if getbufvar(i, '&filetype') == "netrw"
        " echomsg "found netrw buffer. closing..."
        silent exe 'bwipeout ' . i
      endif
    endif
  endfor
endfunction
" }}}
