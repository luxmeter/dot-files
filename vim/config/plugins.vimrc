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
let g:ale_lint_on_enter = 0
" }}}

" Emet {{{
let g:user_emmet_install_global = 0
" }}}

" fzf {{{
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
            \ 'args': ['--tab-width', '2', '--stdin', '--single-quote', '--stdin-filepath', '"%:p"', '--parser', 'yaml', '--print-width', '120'],
            \ 'stdin': 1
            \ }
let g:neoformat_markdown_prettier = {
            \ 'exe': 'prettier',
            \ 'args': ['--tab-width', '2', '--stdin', '--single-quote', '--stdin-filepath', '"%:p"', '--parser', 'markdown', '--print-width', '120'],
            \ 'stdin': 1
            \ }
let g:neoformat_enabled_python = ['black', 'isort']
let g:neoformat_enabled_cmake = ['cmake_format']
let g:neoformat_javascript_prettier = {
            \ 'exe': 'prettier',
            \ 'args': ['--stdin', '--stdin-filepath',  '"%:p"', '--no-semi', '--single-quote', '--trailing-comma', 'es5', '--jsx-bracket-same-line', '--jsx-single-quote', '--arrow-parens', 'always', '--print-width', '120', '--tab-width', '4'],
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

" UltiSnips {{{
" Press enter key to trigger snippet expansion (leverages snippet auto completion)
" inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')
let g:UltiSnipsSnippetDirectories=['mysnippets', 'UltiSnips']
let g:UltiSnipsExpandTrigger = "<c-e>"
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsListSnippets="<c-f>"
" }}}

" Vim Rooter (autochdir) {{{
let g:rooter_manual_only = 1
" }}}


" COC.nvim {{{
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
" may fight with star plugin?
" autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup coc
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" coc }}}
