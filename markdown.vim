"cat >> ~/.vim/ftplugin/markdown.vim << 'EOF'
" markdown specific settings

" Required to let YCM work on markdown
let g:ycm_filetype_blacklist = {}

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

inoremap <F1> <Esc>: silent exec '.!inkscape-figures markdown-create "'.getline('.').'" "./figures/"'<CR><CR>:w<CR>
nnoremap <F1> : silent exec '!inkscape-figures edit "./figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

inoremap <F2> <Esc>: silent exec '.!diagrams-net-figures markdown-create "'.getline('.').'" "./figures/"'<CR><CR>:w<CR>
nnoremap <F2> : silent exec '!diagrams-net-figures edit "./figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

" Enable pptx compilation from f3 keypress
nnoremap <F3> : call CompilePptx() <CR>

" Enable pptx preview from f4 keypress
nnoremap <F4> : call PreviewPptx() <CR>

" Hotkey to copy all snippets to local images folder
nnoremap <F5> : silent exec '!cp ~/Snips/* ./images/ &' <CR><CR>:redraw!<CR>

" Autodetects if template is there in root or not and compiles with it if
" available
function CompilePptx()
   if filereadable("template.pptx")
      silent exec '!pandoc -s ' @% ' -o ' join([split(expand('%:p'),'/')[-1][0:-4],'.pptx'],'') ' --reference-doc template.pptx &'
   else
      silent exec '!pandoc -s ' @% ' -o ' join([split(expand('%:p'),'/')[-1][0:-4],'.pptx'],'') ' &'
   endif
   :redraw!
endfunction

" Preview the pptx if it exists
function PreviewPptx()
   if filereadable(join([split(expand('%:p'),'/')[-1][0:-4],'.pptx'],''))
      silent exec '!libreoffice ' join([split(expand('%:p'),'/')[-1][0:-4],'.pptx'],'') ' &'
   endif
   :redraw!
endfunction

"This is required to get actual auto figure insertion
"along with the installation of the update_tex_figures.sh script
autocmd CursorHold * call RecompileMarkdown() 

autocmd VimEnter * call StartupFunctions()

" TODO need to modify for markdown rendered with pandoc and opened with zathura
" Autorun and kill shortcut watcher run at .tex file launch each time and turn off when done
function RecompileMarkdown()
  silent exec '!update_tex_figures.sh ' expand('%:p:h')
  silent exec '!pandoc -s ' @% ' -o ' join([split(expand('%:p'),'/')[-1][0:-4],'.pdf'],'') ' &'
endfunction

function StartupFunctions()
  call RecompileMarkdown()
  silent exec '!zathura ' join([split(expand('%:p'),'/')[-1][0:-4],'.pdf'],'') ' &'
endfunction
"function ShutdownFunctions()
  "call vimtex#compiler#clean(0)
  "silent exec "!kill $(ps aux | grep '[p]ython3.*main.py' | awk '{print $2}')"
"endfunction

" Activate this with K (shift-k)
"command -nargs=1 Googleit :!python3 ~/.vimfiles/Googleit.py <args>
"set keywordprg=:Googleit

"EOF
