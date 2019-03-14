" Emet {{
let g:user_emmet_install_global = 0
" }}

" ALE {{
let g:ale_linters_sh_shellcheck_exclusions='SC2181,SC1117,SC2155,SC2006,SC2039'

" Airline {{
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
" By default, airline will attempt to load any extension it can find in the 'runtimepath'
let g:airline_extensions = ['ale', 'virtualenv']
let g:airline_symbols.space = "\ua0"
let g:airline_skip_empty_sections = 1
let g:airline_section_b = airline#section#create('%{virtualenv#statusline()}')
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
" let g:airline_theme='papercolor'
let g:airline_theme='twofirewatch'
" }}

" PaperColor
let g:PaperColor_Theme_Options = {
  \   'language': {
  \     'python': {
  \       'highlight_builtins' : 1
  \     },
  \     'cpp': {
  \       'highlight_standard_library': 1
  \     },
  \     'c': {
  \       'highlight_builtins' : 1
  \     }
  \   }
  \ }

" UltiSnips {{
" Unforunately ultisnip is not showing in ycm suggestion list :(
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsListSnippets="<c-f>"
" let g:UltiSnipsUsePythonVersion=3
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

" Smoothscroll {{
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 25, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 25, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>
" }}

" YouCompleteMe {{
" python3 completion
" virtualenv will set python interpreter
let g:ycm_python_binary_path = 'python3'
" let g:ycm_server_python_interpreter = 'python3'
let g:ycm_auto_trigger=0 " if enabled, sometimes the return key doesn't do anything
" below settings are already handled by CursorMovedI and InsertLeave commands
" let g:ycm_autoclose_preview_window_after_completion=1
" let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_goto_buffer_command = 'same-buffer'
let g:jedi#completions_command = "<C-N>"
" }}

" Smoothscroll {{
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 50
" }}

" fzf {{
let g:fzf_action = {
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-x': 'split',
			\ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
	call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
	copen
	cc
endfunction

let g:fzf_action = {
			\ 'ctrl-q': function('s:build_quickfix_list'),
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-x': 'split',
			\ 'ctrl-v': 'vsplit' }
" }}
"
let g:LanguageClient_loggingFile = expand('~/.vim/LanguageClient.log')
" https://github.com/palantir/python-language-server/issues/515
let g:LanguageClient_hasSnippetsSupport = 0
let g:LanguageClient_serverCommands = {'python': ['pyls']}
