" Ag {{{
command! -bang -nargs=* Ag
            \ call fzf#vim#ag(<q-args>, '', { 'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all' }, <bang>0)
" }}}

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
        echom "Filetype is ". &filetype
        " execute('!cd '.l:wd.' && npx tsc --build '.l:wd.' &&  node '.substitute(l:file, ".tsx", ".js", ""))
        execute('silent Shell cd '.l:wd.' && npx tsc --build '.l:wd.' &&  node '.substitute(l:file, ".tsx", ".js", ""))
    else
        echom "No routine for filetype ". &filetype ." found"
    endif
endfunction
" }}}

" RunShellCommand {{{
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
    echo a:cmdline
    let expanded_cmdline = a:cmdline
    for part in split(a:cmdline, ' ')
        if part[0] =~ '\v[%#<]'
            let expanded_part = fnameescape(expand(part))
            let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
        endif
    endfor
    execute "pclose!"
    execute "normal! mm"
    botright vnew
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    call setline(1, 'You entered:    ' . a:cmdline)
    call setline(2, 'Expanded Form:  ' .expanded_cmdline)
    call setline(3,substitute(getline(2),'.','=','g'))
    execute 'silent $read !'. expanded_cmdline
    setlocal nomodifiable
    execute ":set pvw"
    execute "normal! \<C-W>p"
    execute "normal! gg"
    execute "normal! `m"
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

" Ulti-Snippet expandsion on autocomplection {{{
function! ExpandOrClosePopup()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        echom snippet
        return snippet
    else
        return ncm2_ultisnips#expand_or("\<CR>", 'n')
    endif
endfunction
" }}}

" UpdatePythonPath {{{
function! s:CompleteVirtualEnv(arg_lead, cmd_line, cursor_pos)
    return virtualenv#names(a:arg_lead)
endfunction

command! -nargs=? -complete=customlist,s:CompleteVirtualEnv UpdatePythonPath call Update_Python_Path(<q-args>)
function! Update_Python_Path(...)
    let virtual_env = a:1
    if empty(virtual_env)
        " try to guess virtual env
        let root_dir = fnamemodify(FindRootDirectory(), ':t')
        let guess_virtual_env = system(
                    \ 'cd '.$WORKON_HOME.'
                    \ && find . -type d -maxdepth 1
                    \ | grep -i "'.root_dir.'"
                    \ | head -1
                    \ | sed "s|^\./||"')
        if v:shell_error == 0
            let virtual_env = guess_virtual_env
        endif
    endif

    if !empty(virtual_env)
        echom 'Activating virtual env '.virtual_env
        execute ':VirtualEnvActivate '.virtual_env
    endif

    let ver = system($VIRTUAL_ENV. '/bin/python --version | grep -Po ''(\d\.?)+''')
    if ver =~ "\^3."
        let python_path = $HOME. '/.virtualenvs/nvimpy3'
    else
        let python_path =  $HOME. '/.virtualenvs/nvimpy2'
    endif

    if len(python_path) == 0
        echom 'No VirtualEnv set'
    else
        let g:LanguageClient_serverCommands['python'] = [python_path . '/bin/pyls']
        :LanguageClientStop
        :LanguageClientStart
    endif
endfunction
" }}}

" Vimrc {{{
" Likewise, Files command with preview window
command! -bang -nargs=? Vimrc
            \ call fzf#vim#files($DOT_FILES.'/vim/config')
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
