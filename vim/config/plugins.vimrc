" syntastic {{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" }}

" Airline {{
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts=1
let g:airline_enable_branch=1
let g:airline_enable_syntastic=1
let g:airline_detect_paste=1
let g:airline_theme='distinguished'
let g:airline_left_sep = ' '
let g:airline_left_alt_sep = ' '
let g:airline_right_sep = ' '
let g:airline_right_alt_sep = ' '
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ' '
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = ' '
let g:airline#extensions#tabline#formatter = 'unique_tail'
" }}

" UltiSnips {{
" Unforunately ultisnip is not showing in ycm suggestion list :(
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" }}

" CtrlP {{
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
" }}

" IndentLine {{
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_char = '┆'
let g:indentLine_setColors = 0
" }}

" Netrw {{
let g:netrw_banner = 0
let g:netrw_altv = 1
let g:netrw_winsize = 25
" don't use since buffer keeps alive after opening a file
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" }}
