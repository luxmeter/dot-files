" general {{{
augroup general
    autocmd!
    " handy for ctrl-x-f
    autocmd InsertEnter * let s:save_cwd = getcwd() | set autochdir
    autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(s:save_cwd)
    autocmd BufWritePost $MYVIMRC,*.vimrc source $MYVIMRC | silent! AirlineRefresh
    autocmd BufRead,BufNewFile *.md,*.txt,gitcommit setlocal spell | setlocal complete+=kspell
    autocmd BufRead,BufNewFile * let b:autoformat=1 | exec 'FernDo :FernReveal -stay '.expand('%')
    " close netrw buffer (bug)
    autocmd FileType netrw setl bufhidden=wipe | set nobuflisted
    autocmd VimLeavePre *  call QuitNetrw()
    autocmd FileType qf,fern set nobuflisted
    " jump back to quickfix list after deleting entry (quicklist reflector)
    autocmd FileType qf set nobuflisted | noremap <buffer> dd dd :exec winnr('$') . "wincmd w"<cr>
augroup END
" }}}

" programming {{{
augroup programming
    autocmd!
    " vim
    autocmd FileType vim setlocal foldmethod=marker | set fdo-=search " don't open fold when searching
    " python
    autocmd BufWritePre *.py ImpSort!
    " web
    autocmd FileType html,css,javascript,typescript,typescriptreact,javascriptreact EmmetInstall | let b:emmet_installed=1
    " java
    autocmd BufNewFile,BufRead,BufEnter *.java ALEDisable
    autocmd BufLeave *.java ALEEnable
    " general (e.g. formatting)
    au BufWritePre *
        \   if exists('b:autoformat')  && b:autoformat
        \|      try
        \|          undojoin
        \|          Neoformat
        \|      catch /^Vim\%((\a\+)\)\=:E790/
        \|      finally
        \|          silent Neoformat
        \|      endtry
        \|  endif
augroup end
"}}}

" don't use with coc otherwise it interfers coc completion
" omni completion {{{
" augroup omni_complete " {
"     " clear commands before resetting
"     autocmd!
"     autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"     autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" augroup END
" }}}
