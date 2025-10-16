"cat >> ~/.vim/ftplugin/c.vim << 'EOF'
" C/C++ specific settings

" folding view saving specific stuff
" " Turn on autosaving of the view as I like code folding
let g:autosave_view = 0

" Enable gutentags
let g:gutentags_enabled = 1

augroup AutoView
    autocmd!
    " Autosave & Load Views.
    autocmd BufWritePre,BufWinLeave * execute "mkview! " . expand('%:p:h') . "/." . expand('%:t') . ".view"
    autocmd BufWinEnter * execute "silent! source " . expand('%:p:h') . "/." . expand('%:t') . ".view"
augroup END

" IN THE END, ALE IS ONLY LINTING HERE, coc with ccls is doing code completion
" and clang-format is doing formatting, so you can clean up someday when you
" have time to test

let g:ale_fixers = {
    \ 'cpp': ['clang-format'],
    \ 'c': ['clang-format'],
    \ '*': ['remove_trailing_lines', 'trim_whitespace']
\ }
let g:ale_linters = {
    \ 'cpp': ['clangd'],
    \ 'c': ['clangd']
\ }

autocmd BufReadPost *.cpp let b:ale_cpp_clangd_options = '--compile-commands-dir=' . getcwd()
let g:ale_c_clangformat_options = '--style=file:~/.clang-format'
let g:ale_cpp_clangformat_options = '--style=file:~/.clang-format'
let g:ale_fix_on_save = 0

"nnoremap <C-K> :ALEFix<CR>

let g:ale_c_cc_executable = 'gcc'
let g:ale_cpp_cc_executable = 'g++'
let g:__my_gcc_flags__ = '-Wall -Wextra -Wshadow -Wnull-dereference'
let g:ale_c_cc_options = '-std=c17 ' . g:__my_gcc_flags__
let g:ale_cpp_cc_options = '-std=c++17 ' . g:__my_gcc_flags__
"let g:ale_c_clangtidy_checks = [
"         \ '-clang-diagnostic-error',
"         \ '-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling'
"         \ '-clang-analyzer-security.insecureAPI.strcpy'
"         \ ]


" Activate this with K (shift-k)
command -nargs=1 Googleit :!python3 ~/.cfiles/Googleit.py <args>
set keywordprg=:Googleit

" Go with the less obtrusive option just so that you don't have any catastrophic
" file write errors with auto formatting
nnoremap <C-K> :py3f ~/.local/bin/clang-format.py<CR>
"autocmd CursorHold * :py3f ~/.local/bin/clang-format.py
"autocmd BufWrite * :py3f ~/.local/bin/clang-format.py


" Saves as soon as you make the file so compilation works
autocmd BufNewFile * :write

" I turn on autosave on no activity in 500ms here for insert and non insert mode
" many may not like this but after turning on continuous compilation with \ll
" you get live updates without haveing to save manually in tex so im just putting this
" in the tex specific file configuration
autocmd CursorHold,CursorHoldI * update

"let g:ycm_language_server =
"  \ [{
"  \   'name': 'ccls',
"  \   'cmdline': [ 'ccls' ],
"  \   'filetypes': [ 'c', 'cpp', 'h', 'hpp', 'cuda', 'objc', 'objcpp' ],
"  \   'project_root_files': [ '.ccls-root', 'compile_commands.json' ]
"  \ }]
