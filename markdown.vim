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

nnoremap <F10> : silent exec '!zathura ' join([split(expand('%:p'),'/')[-1][0:-4],'.pdf'],'') ' &' <CR><CR>:redraw!<CR>

" Hotkey to make all figures
nnoremap <F11> : call ForceCompileAllFigures() <CR>

" Hotkey to make all plots
nnoremap <F12> : call ForceCompileAllPlots() <CR> 


" Autodetects if template is there in root or not and compiles with it if
" available
function CompilePptx()
   if filereadable("template.pptx")
      silent exec '!run_pandoc_commands.sh ' expand('%:p:h') ' -mdtpptx ' expand('%:r') ' > /dev/null 2>&1 &'
   else
      silent exec '!run_pandoc_commands.sh ' expand('%:p:h') ' -mdtpptxnt ' expand('%:r') ' > /dev/null 2>&1 &'
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
autocmd VimLeave * call RecompileMarkdownFinal()

function RecompileMarkdown()
  silent exec '!update_tex_figures.sh ' expand('%:p:h') ' -m > /dev/null 2>&1 &'
  :redraw!
  silent exec '!make_gnuplots.sh ' expand('%:p:h') ' -m > /dev/null 2>&1 &'
  :redraw!
  silent exec '!run_pandoc_commands.sh ' expand('%:p:h') ' -mdtpdf ' expand('%:r') ' > /dev/null 2>&1 &'
  :redraw!
endfunction

function ForceCompileAllFigures()
  silent exec '!update_tex_figures.sh ' expand('%:p:h') ' -f > /dev/null 2>&1 &'
  :redraw!
endfunction

function ForceCompileAllPlots()
  silent exec '!make_gnuplots.sh ' expand('%:p:h') ' -f > /dev/null 2>&1 &'
  :redraw!
endfunction

function StartupFunctions()
  call RecompileMarkdown()
  silent exec '!zathura ' join([split(expand('%:p'),'/')[-1][0:-4],'.pdf'],'') ' &'
endfunction

function RecompileMarkdownFinal()
  silent exec '!update_tex_figures.sh ' expand('%:p:h') ' -m > /dev/null 2>&1 &'
  :redraw!
  silent exec '!make_gnuplots.sh ' expand('%:p:h') ' -m > /dev/null 2>&1 &'
  :redraw!
  silent exec '!run_pandoc_commands.sh ' expand('%:p:h') ' -mdttexwtfp ' expand('%:r') ' > /dev/null 2>&1 &'
  :redraw!
endfunction

" Activate this with K (shift-k)
"command -nargs=1 Googleit :!python3 ~/.vimfiles/Googleit.py <args>
"set keywordprg=:Googleit

"EOF
