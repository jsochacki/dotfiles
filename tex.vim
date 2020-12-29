"cat >> ~/.vim/ftplugin/tex.vim << 'EOF'
" tex specific settings

" Crucial to allow ycm and ultisnips to work together
" cant tab complete ultisnips if you don't do this
" free per https://vim.fandom.com/wiki/Unused_keys
let g:ycm_key_list_select_completion=['<C-B>']
let g:ycm_key_list_previous_completion=['<C-J>']

" Load YouCompleteMe
packadd YouCompleteMe

" Saves as soon as you make the file so compilation works
autocmd BufNewFile * :write

" I turn on autosave on no activity in 500ms here for insert and non insert mode
" many may not like this but after turning on continuous compilation with \ll
" you get live updates without haveing to save manually in tex so im just putting this
" in the tex specific file configuration
autocmd CursorHold,CursorHoldI * update
set updatetime=500

inoremap <F1> <Esc>: silent exec '.!inkscape-figures latex-create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
nnoremap <F1> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

inoremap <F2> <Esc>: silent exec '.!diagrams-net-figures latex-create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
nnoremap <F2> : silent exec '!diagrams-net-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

" Hotkey to copy all snippets to local images folder
nnoremap <F5> : silent exec '![[ $(ls -A ~/Snips/) ]] && cp ~/Snips/* ./images/ && rm ~/Snips/*' <CR><CR>:redraw!<CR>

"This is required to get actual auto figure insertion
"along with the installation of the update_tex_figures.sh script
autocmd CursorHold * : silent exec '!update_tex_figures.sh ' expand('%:p:h')


" Starts autocompilation at .tex file open and cleansup at close and shortcut watcher
augroup vimtex_event_1
  au!
  au User VimtexEventQuit     call ShutdownFunctions()
  au User VimtexEventInitPost call StartupFunctions()
augroup END

" Autorun and kill shortcut watcher run at .tex file launch each time and turn off when done
function StartupFunctions()
  call vimtex#compiler#compile()
  silent exec '!python3 ~/.local/lib/python3.8/site-packages/inkscape-latex-shortcuts/main.py &'
endfunction
function ShutdownFunctions()
  call vimtex#compiler#clean(0)
  silent exec "!kill $(ps aux | grep '[p]ython3.*main.py' | awk '{print $2}')"
endfunction

" Activate this with K (shift-k)
"command -nargs=1 Googleit :!python3 ~/.vimfiles/Googleit.py <args>
"set keywordprg=:Googleit

"EOF
