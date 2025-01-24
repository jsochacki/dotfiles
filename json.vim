" folding view saving specific stuff
" " Turn on autosaving of the view as I like code folding
" Without the following it will load BOTH the javascriptreact.vim file and
" then the javascript.vim file

let g:autosave_view = 0

augroup AutoView
    autocmd!
    " Autosave & Load Views.
    autocmd BufWritePre,BufWinLeave * execute "mkview! " . expand('<afile>:p:h') . "/." . expand('<afile>:t') . ".view"
    autocmd BufWinEnter * execute "silent! source " . expand('%:p:h') . "/." . expand('%:t') . ".view"
augroup END

let g:ale_fixers = {
    \ 'json': ['fixjson'],
    \ '*': ['remove_trailing_lines', 'trim_whitespace']
\ }
let g:ale_linters = {
    \ 'json': ['jsonlint']
\ }

let g:ale_fix_on_save = 0

nnoremap <C-K> :ALEFix<CR>

let g:ale_json_fixjson_executable = 'fixjson'
"let g:ale_json_fixjson_options = 
let g:ale_json_jsonlint_executable = 'jsonlint'
