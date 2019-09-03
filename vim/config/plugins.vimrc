" Airline {{{
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
" By default, airline will attempt to load any extension it can find in the 'runtimepath'
" let g:airline_extensions = ['ale', 'virtualenv', 'branch', 'bufferline']
let g:airline_symbols.space = "\ua0"
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts=1
let g:airline_enable_syntastic=1
let g:airline_detect_paste=1
let g:airline_theme='zenburn'
let g:airline_left_sep = ' '
let g:airline_left_alt_sep = ' '
let g:airline_right_sep = ' '
let g:airline_right_alt_sep = ' '
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1 " tab and buffer line
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ' '
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = ' '
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_mode_map = {
            \ '__' : '-',
            \ 'c'  : 'C',
            \ 'i'  : 'I',
            \ 'ic' : 'I',
            \ 'ix' : 'I',
            \ 'n'  : 'N',
            \ 'ni' : 'N',
            \ 'no' : 'N',
            \ 'R'  : 'R',
            \ 'Rv' : 'R',
            \ 's'  : 'S',
            \ 'S'  : 'S',
            \ '' : 'S',
            \ 't'  : 'T',
            \ 'v'  : 'V',
            \ 'V'  : 'V',
            \ '' : 'V',
            \ }

function! AirlineInit()
    let g:airline_section_b = airline#section#create(['branch','%{virtualenv#statusline()}'])
    let g:airline_section_c = airline#section#create(['hunks','%f'])
endfunction
autocmd VimEnter * call AirlineInit()
" }}}

" ALE {{{
let g:ale_linters_sh_shellcheck_exclusions='SC2181,SC1117,SC2155,SC2006,SC2039'
" }}}

" Emet {{{
let g:user_emmet_install_global = 0
" }}}

" fzf {{{
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

command! -bang -nargs=* Ag
            \ call fzf#vim#ag(<q-args>, '', { 'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all' }, <bang>0)
" }}}

" LanguageClient {{{
let g:LanguageClient_loggingFile = expand('~/.vim/LanguageClient.log')
" https://github.com/palantir/python-language-server/issues/515
let g:LanguageClient_hasSnippetsSupport = 1
" we have ALE for linting
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_serverCommands = {
            \ 'python': ['tcp://127.0.0.1:2087'],
            \ 'javascript': ['tcp://127.0.0.1:2089'],
            \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
            \ 'typescript.jsx': ['tcp://127.0.0.1:2089']
            \ }

function! LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <F1> :call LanguageClient_contextMenu()<CR>
        nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
        nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
        nnoremap <buffer> <silent> <F6> :call LanguageClient#textDocument_rename()<CR>
    endif
endfunction

augroup languageClient
    autocmd!
    autocmd VimEnter,BufNewFile,BufRead,BufEnter,Filetype * call LC_maps()
augroup end
" }}}

" NCM2 {{{
augroup ncm2
    autocmd!
    " enable NCM2 for all buffers
    autocmd BufEnter * call ncm2#enable_for_buffer()
augroup END
" }}}

" NeoFormat {{{
let g:neoformat_try_formatprg = 1
" let b:neoformat_run_all_formatters = 0
let g:neoformat_basic_format_align = 0 " Enable alignment globally
let g:neoformat_basic_format_retab = 0 " Enable tab to spaces conversion globally
let g:neoformat_basic_format_trim = 1
let g:neoformat_yaml_prettier = {
            \ 'exe': 'prettier',
            \ 'args': ['--tab-width', '2', '--stdin', '--single-quote', '--stdin-filepath', '"%:p"', '--parser', 'yaml'],
            \ 'stdin': 1
            \ }
let g:neoformat_markdown_prettier = {
            \ 'exe': 'prettier',
            \ 'args': ['--tab-width', '2', '--stdin', '--single-quote', '--stdin-filepath', '"%:p"', '--parser', 'markdown'],
            \ 'stdin': 1
            \ }
" }}}

" Netrw {{{
let g:netrw_banner = 0
let g:netrw_altv = 1
let g:netrw_winsize = 25
" don't use since buffer keeps alive after opening a file
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" }}}

" SimplyFold {{{
let g:SimpylFold_fold_docstring = 0
" }}}

" Smoothscroll {{{
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 25, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 25, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>
" }}}

" UltiSnips {{{
" Press enter key to trigger snippet expansion (leverages snippet auto completion)
" inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')
let g:UltiSnipsSnippetDirectories=[$HOME.'/.snippets', 'UltiSnips']
let g:UltiSnipsExpandTrigger = "<c-e>"
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsListSnippets="<c-f>"
" }}}
