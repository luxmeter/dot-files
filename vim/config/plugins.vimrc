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
let g:airline_theme='onedark'
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
    " let g:airline_section_b = airline#section#create(['branch','%{virtualenv#statusline()}']) " too slow
    let g:airline_section_b = airline#section#create(['branch'])
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

" AsyncRun {{{
let g:asyncrun_open = 5
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
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-eslint',
    \ 'coc-marketplace',
    \ 'coc-jedi',
    \ 'coc-vimlsp',
    \ 'coc-ultisnips',
    \ 'coc-json',
    \ 'coc-css'
\ ]

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
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
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
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <Leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <Leader>f  <Plug>(coc-format-selected)
nmap <Leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <Leader>a  <Plug>(coc-codeaction-selected)
nmap <Leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <Leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <Leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

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

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" coc }}}

" fern {{{

" Custom settings and mappings.
let g:fern#disable_default_mappings = 1
let g:fern_git_status#disable_ignored    = 1
let g:fern_git_status#disable_untracked  = 1
let g:fern_git_status#disable_submodules = 1

noremap  <F1> :Fern . -drawer -reveal=% -toggle -width=35<CR>

function! FernInit() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
nmap <buffer><nowait> <F5> <Plug>(fern-action-reload)
nmap <buffer><nowait> <Return> <Plug>(fern-action-enter)
nmap <buffer><nowait> <Backspace> <Plug>(fern-action-leave)
nmap <buffer><nowait> l <Plug>(fern-action-expand)
nmap <buffer><nowait> h <Plug>(fern-action-collapse)
nmap <buffer><nowait> i <Plug>(fern-action-reveal)
nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
nmap <buffer> <C-N> <Plug>(fern-action-new-path)
nmap <buffer> dd <Plug>(fern-action-remove)
nmap <buffer> m <Plug>(fern-action-move)
nmap <buffer> <F2> <Plug>(fern-action-rename)
nmap <buffer> <Tab> <Plug>(fern-action-mark:toggle)
nmap <buffer> <C-S> <Plug>(fern-action-open:split)
nmap <buffer> <C-V> <Plug>(fern-action-open:vsplit)
nmap <buffer> <nowait> . <Plug>(fern-action-hidden:toggle)
nmap <buffer><nowait> <Left> <Plug>(fern-action-collapse)
nmap <buffer><nowait> <Right> <Plug>(fern-action-expand)
endfunction

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END
"}}}
