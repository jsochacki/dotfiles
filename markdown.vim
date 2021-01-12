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
"nnoremap <F5> : silent exec '![[ $(ls -A ~/Snips/) ]] && cp ~/Snips/* ./images/ && rm ~/Snips/*' <CR><CR>:redraw!<CR>
nnoremap <F5> : silent exec '![[ $(ls -A ~/Snips/) ]] && mv ~/Snips/* ./images/' <CR><CR>:redraw!<CR>

" Hotkey to make all plots
nnoremap <F6> : silent exec '!make_gnuplots.sh ' expand('%:p:h') ' > /dev/null 2>&1' <CR><CR>:redraw!<CR>

" Hotkey to re-open zathura and preview the file for when it crashes
nnoremap <F12> : call RecompileMarkdown() <CR>

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
" Recompiles on :w entry (i.e. manual save)
autocmd  BufWritePost * call RecompileMarkdown() 
" Ok for small simple markdown files but for mine with all teh scripts running
" and image conversion this leads to a lot of failed pdf viewing so don't do it
" Recompiles on cursor pause of 500ms in normal entry mode
"autocmd  CursorHold * call RecompileMarkdown() 

autocmd VimEnter * call StartupFunctions()
autocmd VimLeave * call ShutdownFunctions()

function RecompileMarkdown()
  silent exec '!update_tex_figures.sh ' expand('%:p:h') ' > /dev/null 2>&1 &'
  :redraw!
  silent exec '!pandoc -s -f markdown-implicit_figures -t pdf ' @% ' -o ' join([split(expand('%:p'),'/')[-1][0:-4],'.pdf'],'') ' &'
  :redraw!
endfunction

function StartupFunctions()
  call RecompileMarkdown()
  silent exec '!zathura ' join([split(expand('%:p'),'/')[-1][0:-4],'.pdf'],'') ' &'
endfunction
function ShutdownFunctions()
  silent exec '![[ $(ls ' join([expand('%:p:h'),'/build/'],'') ') ]] && rm ' join([expand('%:p:h'),'/build/','*'],'') ' &'
endfunction

" Theoretically more stable but really slow and still not that good tbh
"function RecompileMarkdown()
"  silent exec '!update_tex_figures.sh ' expand('%:p:h') ' > /dev/null 2>&1'
"  :redraw!
"  silent exec '!pandoc -s -f markdown-implicit_figures -t latex ' @% ' -o ' join([expand('%:p:h'),'/build/',expand('%:r'),'.tex'],'') ' > /dev/null 2>&1'
"  :redraw!
"  silent exec '!pdflatex -interaction=nonstopmode -synctex=1 ' join([expand('%:p:h'),'/build/',expand('%:r'),'.tex'],'') ' -o ' join([expand('%:p:h'),'/build/',expand('%:r'),'.pdf'],'') ' > /dev/null 2>&1'
"  :redraw!
"  silent exec '!mv ' join([expand('%:p:h'),'/build/',expand('%:r'),'.pdf'],'') join([expand('%:p:h'),'/',expand('%:r'),'.pdf'],'') ' &'
"endfunction

" Activate this with K (shift-k)
"command -nargs=1 Googleit :!python3 ~/.vimfiles/Googleit.py <args>
"set keywordprg=:Googleit

"EOF
