" folding view saving specific stuff
" " Turn on autosaving of the view as I like code folding
" Without the following it will load BOTH the javascriptreact.vim file and
" then the javascript.vim file
if &filetype == 'javascriptreact'
    finish
endif

let g:autosave_view = 0

" Enable gutentags
let g:gutentags_enabled = 1

augroup AutoView
    autocmd!
    " Autosave & Load Views.
    autocmd BufWritePre,BufWinLeave * execute "mkview! " . expand('<afile>:p:h') . "/." . expand('<afile>:t') . ".view"
    autocmd BufWinEnter * execute "silent! source " . expand('%:p:h') . "/." . expand('%:t') . ".view"
augroup END
 
" Prettier is built into my eslint file and is better to do that way
"let g:ale_fixers = {
"    \ 'javascript': ['eslint', 'prettier'],
"    \ '*': ['remove_trailing_lines', 'trim_whitespace']
"\ }
let g:ale_fixers = {
    \ 'javascript': ['eslint'],
    \ '*': ['remove_trailing_lines', 'trim_whitespace']
\ }
let g:ale_linters = {
    \ 'javascript': ['eslint']
\ }

let g:ale_fix_on_save = 0

nnoremap <C-K> :ALEFix<CR>

let g:ale_javascript_eslint_executable = 'eslint'
let g:ale_javascript_eslint_options = '--config ~/.config/eslint/eslint.config.mjs'
let g:ale_javascript_prettier_executable = 'prettier'
let g:ale_javascript_prettier_options = '--config ~/.config/prettier/.prettierrc'
