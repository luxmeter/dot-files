" general {{{
augroup general
    autocmd!
    " handy for ctrl-x-f
    autocmd InsertEnter * let s:save_cwd = getcwd() | set autochdir
    autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(s:save_cwd)
    autocmd BufWritePost $MYVIMRC,*.vimrc source $MYVIMRC | silent! AirlineRefresh
    autocmd BufRead,BufNewFile *.md,*.txt,gitcommit setlocal spell | setlocal complete+=kspell
augroup END
" }}}

" programming {{{
augroup programming
    autocmd!
    " vim
    autocmd FileType vim setlocal foldmethod=marker
    " python
    autocmd BufWritePre *.py ImpSort!
    " web
    autocmd FileType html,css,javascript,typescript EmmetInstall
    " java
    autocmd BufNewFile,BufRead,BufEnter *.java ALEDisable
    autocmd BufLeave *.java ALEEnable
    " general (e.g. formatting)
    au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
augroup end
"}}}

" newtr bugfix {{{
" https://vi.stackexchange.com/questions/14622/how-can-i-close-the-netrw-buffer
augroup netrw_buf_hidden_fix " {
    autocmd!
    " Set all non-netrw buffers to bufhidden=hide
    autocmd BufWinEnter *
                \  if &ft != 'netrw'
                \|     set bufhidden=hide
                \| endif
augroup end
" }}}

" omni completion {{{
augroup omni_complete " {
    " clear commands before resetting
    autocmd!
    autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
    autocmd InsertLeave * if pumvisible() == 0|pclose|endif
augroup END
" }}}
