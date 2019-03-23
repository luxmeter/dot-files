" execute('!npx tsc '.expand("%").' && node '.substitute(expand('%'), ".tsx", ".js", ""))
augroup general " {
	autocmd!
	" entering ins-mode changes the cwd to the parent dir of the opened file
	" handy for ctrl-x-f
	autocmd InsertEnter * let save_cwd = getcwd() | set autochdir
	autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(save_cwd)
	" reload vim script
	autocmd BufWritePost $MYVIMRC,*.vimrc source $MYVIMRC | silent! AirlineRefresh
	autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
	autocmd BufRead,BufNewFile *yaml,*.md,*.txt,gitcommit setlocal spell | setlocal complete+=kspell
	autocmd BufWritePre *.py ImpSort!
	autocmd BufWritePre *.js,*.jsx,*.tsx,*.ts Neoformat
	autocmd FileType html,css EmmetInstall
	" disable ALE on java files
	autocmd BufNewFile,BufRead,BufEnter *.java ALEDisable
	autocmd BufLeave *.java ALEEnable
	autocmd BufEnter *.md setlocal foldexpr=MarkdownLevel()
	autocmd BufEnter *.md setlocal foldmethod=expr
    autocmd FileType * call LC_maps()
	" enable ncm2 for all buffers
	autocmd BufEnter * call ncm2#enable_for_buffer()
augroup END " }

" fix newtr buffer bug
" https://vi.stackexchange.com/questions/14622/how-can-i-close-the-netrw-buffer
set nohidden
augroup netrw_buf_hidden_fix " {
	autocmd!
	" Set all non-netrw buffers to bufhidden=hide
	autocmd BufWinEnter *
				\  if &ft != 'netrw'
				\|     set bufhidden=hide
				\| endif
augroup end " }

augroup omni_complete " {
	" clear commands before resetting
	autocmd!
	autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
	autocmd InsertLeave * if pumvisible() == 0|pclose|endif
	" Enable omnicomplete for supported filetypes
	autocmd FileType css,scss setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	" only availble with +python, can lead to segmentfault with python2 and 3 enabled
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
	autocmd FileType javascript,typescript,typescript.jsx setlocal formatprg=prettier\ --stdin\ --single-quote\ --trailing-comma\ es5
	" Use formatprg when available
	let g:neoformat_try_formatprg = 1
augroup END " }

augroup fzf " {
	autocmd!
	" query, ag options, fzf#run options, fullscreen
	autocmd VimEnter *
				\ command! -bang -nargs=* Ag
				\ call fzf#vim#ag(<q-args>, '', { 'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all' }, <bang>0)
augroup end " }
