"cat >> ~/.vim/ftplugin/c.vim << 'EOF'
" C/C++ specific settings

" Crucial to allow ycm and ultisnips to work together
" cant tab complete ultisnips if you don't do this
" free per https://vim.fandom.com/wiki/Unused_keys
let g:ycm_key_list_select_completion=['<C-B>']
let g:ycm_key_list_previous_completion=['<C-J>']

" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */

" Load YouCompleteMe
packadd YouCompleteMe

" Clangd Setup
" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = exepath("clangd")
let g:ycm_clangd_args = ['-log=verbose', '-pretty']
" Set path to global conf file
let g:ycm_global_ycm_extra_conf = '~/.cfiles/.ycm_extra_conf.py'

" Add mappings for YCM
" S is a synonim for s and s is a synonim for cl
" but we do use s from time to time so use x as that is a synonim for dl
nnoremap S :YcmCompleter GoTo<CR>
nnoremap x :YcmCompleter GetType<CR>
nnoremap _ :YcmCompleter RefactorRename 
nnoremap Y :YcmCompleter GetDoc<CR>

" Activate this with K (shift-k)
command -nargs=1 Googleit :!python3 ~/.cfiles/Googleit.py <args>
set keywordprg=:Googleit

" Go with the less obtrusive option just so that you don't have any catastrophic
" file write errors with auto formatting
nnoremap <C-K> :py3f ~/.local/bin/clang-format.py<CR>
"autocmd CursorHold * :py3f ~/.local/bin/clang-format.py
"autocmd BufWrite * :py3f ~/.local/bin/clang-format.py

"EOF
