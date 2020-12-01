#!/bin/bash

# Get rid of firefox
sudo apt-get purge -y firefox

# Get git, curl, and make
sudo apt-get install -y git curl make

# Get vim
sudo apt-get install -y vim build-essential clang-format

# you need to run this from the git directory

./install_and_setup_texlive.sh

# Get window managers and window management utilities
sudo apt-get install -y tmux bspwm i3 feh rxvt
# https://i3wm.org/docs/userguide.html

# Get PDF Viewer
sudo apt-get install -y zathura zathura-pdf-poppler

# Get latex compiler for vimtex
sudo apt-get install -y latexmk xzdec
# Get for forward searching in zatuhura with vimtex
sudo apt-get install -y xdotool
# Get inkscape for non diagram figures and prefent "Failed to load module "canberra-gtk-module"" error
sudo apt-get install -y libcanberra-gtk-module libcanberra-gtk3-module inkscape
# Need these to support automated vimtex inkscape interaction
sudo apt-get install -y python3.8-dev rofi python3-pip

# Need to actually get pip3.8 as well
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.8 get-pip.py
rm get-pip.py
#Prevents errors due to sudo run setting USER as root
TMPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd
TMPOUT=$(pwd)
cd $TMPDIR
echo '' >> ~/.bashrc
echo '# Adding path for latex helpers' >> ~/.bashrc
echo 'export PATH="'$TMPOUT'/.local/bin:$PATH"' >> ~/.bashrc

#Do now so you can finish setup without leaving the script
export PATH=$TMPOUT/.local/bin:$PATH

sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
sudo update-alternatives  --set python3 /usr/bin/python3.8
#Can run this to visually check
#sudo update-alternatives --config python
#or this
#python3 --version

# Finally install
# old way that you cant customize
#pip3.8 install inkscape-figures
# New way that you can
#cd $TMPOUT/.local/lib/python3.8/site-packages/
#git clone https://github.com/jsochacki/inkscape-latex-figures.git
#cd inkscape-latex-figures
#sudo pip3.8 install --user .
cd
git clone https://github.com/jsochacki/inkscape-latex-figures.git
cd inkscape-latex-figures
pip3.8 install --user .
cd ../
rm -rf inkscape-latex-figures

# Install the python version i made for diagrams.net images
git clone https://github.com/jsochacki/diagrams-net-figures.git
cd diagrams-net-figures
pip3.8 install --user .
cd ../
rm -rf diagrams-net-figures

#inkscape shortcut manager setup
#cd $TMPOUT/.local/lib/python3.8/site-packages/
#git clone https://github.com/python-xlib/python-xlib.git
#cd python-xlib
##sudo python3 setup.py install
#sudo pip3.8 install --user .
#cd ../
git clone https://github.com/python-xlib/python-xlib.git
cd python-xlib
pip3.8 install --user .
cd ../
rm -rf python-xlib

# Clone from original and modify
#git clone https://github.com/gillescastel/inkscape-shortcut-manager.git
#cp $TMPDIR/None.rasi $TMPOUT/.local/lib/python3.8/site-packages/inkscape-shortcut-manager/None.rasi
#cp $TMPDIR/inkscape-shortcut-manager-vim.py $TMPOUT/.local/lib/python3.8/site-packages/inkscape-shortcut-manager/vim.py
# Just clone from mine instead
cd $TMPOUT/.local/lib/python3.8/site-packages/
git clone https://github.com/jsochacki/inkscape-latex-shortcuts.git
cd $TMPDIR



sudo apt-get install -y xclip pdf2svg
# It isn't in his list but you need urxvt to use text insertion etc...
#sudo apt-get install -y rxvt
# I already get it though for i3 so we are good


#"install" my script
#Not safe
#homedir=$(eval echo ~$USER)
#Prevents errors due to sudo run setting USER as root
TMPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd
homedir=$(pwd)
cd $TMPDIR
cp update_tex_figures.sh $homedir/.local/bin/update_tex_figures.sh

# Get vim-plug and set it up
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim



cat >> ~/.vimrc.plugged << 'EOF'
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
" Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
" Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

" All that was info for future changes so actually load plugins here
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=2
let g:tex_conceal='abdmg'

" A lot less clean of a look if you use this but a lot more concealing
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
set conceallevel=2
let g:tex_conceal='abdmg'
"hi Conceal ctermbg=none
let g:tex_conceal_frac=1

setlocal spell
set spelllang=en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Get Utilisnip plugin for snippits
Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" Get Colorschemes
Plug 'flazz/vim-colorschemes'

" Get file specific setting plugins here
"Plug 'vim-scripts/c.vim'
"let  g:C_UseTool_cmake    = 'yes'
"let  g:C_UseTool_doxygen = 'yes'


" Initialize plugin system
call plug#end()

EOF


cat >> ~/.vimrc.normal << 'EOF'

" Turn on builting plugins
filetype plugin on


" Add general security options here
" exrc forces vim to use the .vimrc in the local directory allowing for per directory customization
set exrc
" This restricts non home dir vimrc commands to keep local vimrc use secure so may cause problems
" if there are issues start here
set secure
" Set not compatible
set nocompatible

" Setting options from this talk here mcantor/no_plugins
set path+=**
set wildmenu
" Now we can hit tab to find by partial match and use * for wildcards
" - :b lets you autocomplete any open buffer


" Add basic vim Setup Options here
set tabstop=3
set softtabstop=3
set shiftwidth=3
set expandtab
set colorcolumn=80
set wrap
set textwidth=80
set showbreak=-linebreak-
"set nowrap
"set fo-=t
highlight ColorColumn ctermbg=darkgray

" Enable sytax highlighting
" Note using syntax on means vim will override your syntax settings vs enable where it will not
syntax enable
" Turn on line numbers
set nu
" Enable mouse
set mouse=a
set ttymouse=xterm2
" Set terminal title
set title
" Lots of undo steps
set undolevels=1000
" Match the default braces with cursor highlighting and also match <>
set showmatch
set cursorline
set matchpairs+=<:>
" Display tab characters as "|---" and spaces as ".", but only trailing spaces
set list
set listchars=tab:\|-,trail:.,extends:#,nbsp:.
" Folding options
set foldcolumn=1
hi FoldColumn ctermbg=NONE
set foldopen-=block

" set UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

" to taste, disble if you don't like
set autoindent
set smartindent
set cindent

EOF


# Can just add in initial vimrc creation but techincally since it doesn't exist when it runs before
# you install the plugins it makes you press enter so i'll just add at the appropriate time here
echo '' >> ~/.vimrc.colors
echo '"add color scheme setup here' >> ~/.vimrc.colors
echo 'colorscheme molokai' >> ~/.vimrc.colors
echo '' >> ~/.vimrc.colors
echo '' >> ~/.vimrc.colors


cat >> ~/.vimrc.custom << 'EOF'

" Add long list of very custom vim options here

" Automatic view saving
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set viewoptions=cursor,folds,slash,unix

if !exists("g:autosave_view")
    let g:autosave_view = 0
endif

function! MakeViewCheck()
    " If we're not configured to autosave
    if g:autosave_view == 0 | return 0 | endif
    " if we're in diff mode
    if &l:diff | return 0 | endif
    " If we're not a file
    if &buftype != '' | return 0 | endif
    if expand('%') =~ '\[.*\]' | return 0 | endif
    " File does not exist on disk
    if empty(glob(expand('%:p'))) | return 0 | endif
    if &modifiable == 0 | return 0 | endif
    " If we're in the temp dir
    if len($TEMP) && expand('%:p:h') == $TEMP | return 0 | endif
    if len($TMP) && expand('%:p:h') == $TMP | return 0 | endif

    return 1
endfunction

augroup AutoView
    autocmd!
    " Autosave & Load Views.
    autocmd BufWritePre,BufWinLeave ?* if MakeViewCheck() | silent! mkview | endif
    autocmd BufWinEnter ?* if MakeViewCheck() | silent! loadview | endif
augroup END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Shortcut (\t): Set 4 char space tabs
"nmap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
"Shortcut (\T): Set 8 char space tabs
"nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=8<CR>
"Shortcut (\m): Set 4 char tab tabs
"nmap \m :set noexpandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
"Shortcut (\M): Set 8 char tab tabs
"nmap \M :set noexpandtab tabstop=8 shiftwidth=8 softtabstop=8<CR>

" Shortcut (\woo): Toggle line wrapping at line limit
nmap \woo :call AutoWrapToggle()<CR>
function! AutoWrapToggle()
    if &formatoptions =~ 't'
        set fo-=t
    else
        set fo+=t
    endif
endfunction


" Can change MakeTags to anything you want
"command! MakeTags !ctags -R .

let t:is_transparent = 1
hi Normal guibg=NONE ctermbg=NONE
" Or just use this if you want it to start off in molokai
" let t:is_transparent = 0
function! Toggle_transparent_background()
  if t:is_transparent == 1
    :color molokai
    let t:is_transparent = 0
else
    hi Normal guibg=NONE ctermbg=NONE
    let t:is_transparent = 1
endif
endfunction
nnoremap <C-H> :call Toggle_transparent_background()<CR>

nnoremap j h
nnoremap k j
nnoremap l k
nnoremap ; l

EOF


cat >> ~/.vimrc << 'EOF'

" Source broken out vimrc files
source ~/.vimrc.plugged
source ~/.vimrc.normal
source ~/.vimrc.colors
source ~/.vimrc.custom

EOF


mkdir -p  ~/.vim/ftplugin/

cat >> ~/.vim/ftplugin/c.vim << 'EOF'
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

EOF


cat >> ~/.vim/ftplugin/python.vim << 'EOF'
" Python3 specific settings

" Crucial to allow ycm and ultisnips to work together
" cant tab complete ultisnips if you don't do this
" free per https://vim.fandom.com/wiki/Unused_keys
let g:ycm_key_list_select_completion=['<C-B>']
let g:ycm_key_list_previous_completion=['<C-J>']

" intelligent comments (cant figure out right now)
" set comments=sl:\"\"\",mb:\ ,elx:\ \"\"\"

" Load YouCompleteMe
packadd YouCompleteMe

" ycm python Setup
let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
" Set path to global conf file
let g:ycm_global_ycm_extra_conf = '~/.pyfiles/.ycm_extra_conf.py'

" Add mappings for YCM
" S is a synonim for s and s is a synonim for cl
" but we do use s from time to time so use x as that is a synonim for dl
nnoremap S :YcmCompleter GoTo<CR>
nnoremap x :YcmCompleter GetType<CR>
nnoremap _ :YcmCompleter RefactorRename 
nnoremap Y :YcmCompleter GetDoc<CR>

" Activate this with K (shift-k)
command -nargs=1 Googleit :!python3 ~/.pyfiles/Googleit.py <args>
set keywordprg=:Googleit

EOF


cat >> ~/.vim/ftplugin/tex.vim << 'EOF'
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

inoremap <F1> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
nnoremap <F1> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

inoremap <F2> <Esc>: silent exec '.!diagrams-net-figures latex-create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
nnoremap <F2> : silent exec '!diagrams-net-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

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

EOF


cat >> ~/.vim/ftplugin/markdown.vim << 'EOF'
" markdown specific settings

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

"TODO update the inkscape-figures repo to accomodate inkscape files in markdown
"inoremap <F1> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
"nnoremap <F1> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

inoremap <F2> <Esc>: silent exec '.!diagrams-net-figures markdown-create "'.getline('.').'" "./figures/"'<CR><CR>:w<CR>
nnoremap <F2> : silent exec '!diagrams-net-figures edit "./figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

"This is required to get actual auto figure insertion
"along with the installation of the update_tex_figures.sh script
autocmd CursorHold * : silent exec '!update_tex_figures.sh ' expand('%:p:h')


" Starts autocompilation at .tex file open and cleansup at close and shortcut watcher
augroup marktex_event_1
  au!
  au User MarktexEventQuit     call ShutdownFunctions()
  au User MarktexEventInitPost call StartupFunctions()
augroup END

" TODO need to modify for markdown rendered with pandoc and opened with zathura
" Autorun and kill shortcut watcher run at .tex file launch each time and turn off when done
"function StartupFunctions()
  "call vimtex#compiler#compile()
  "silent exec '!python3 ~/.local/lib/python3.8/site-packages/inkscape-latex-shortcuts/main.py &'
"endfunction
"function ShutdownFunctions()
  "call vimtex#compiler#clean(0)
  "silent exec "!kill $(ps aux | grep '[p]ython3.*main.py' | awk '{print $2}')"
"endfunction

" Activate this with K (shift-k)
"command -nargs=1 Googleit :!python3 ~/.vimfiles/Googleit.py <args>
"set keywordprg=:Googleit

EOF


# Do some non vimrc setup
# place ultisnips
mkdir -p ~/.vim/UltiSnips
cd $TMPDIR
cp tex.snippets ~/.vim/UltiSnips/
cp cpp.snippets ~/.vim/UltiSnips/
cp c.snippets ~/.vim/UltiSnips/
cp cu.snippets ~/.vim/UltiSnips/


#Manual youcompletemeinstall if plug doesn't work which it shouldnt
./install_and_setup_youcompleteme.sh


# Copy over scripts and config files
mkdir -p ~/.local/bin
cp myclang-format.py3 ~/.local/bin/clang-format.py
cp .clang-format ~/
mkdir -p ~/.config/zathura/
cp zathurarc ~/.config/zathura/
mkdir -p ~/.config/i3/
cp i3config ~/.config/i3/config
cp .Xresources ~/
mkdir -p ~/.cfiles
cp c.ycm_extra_conf.py ~/.cfiles/.ycm_extra_conf.py
mkdir -p ~/.pyfiles
cp py.ycm_extra_conf.py ~/.pyfiles/.ycm_extra_conf.py
# Dont actually need to do this below to get urxvt settings to take
#echo 'xrdb ~/.Xresources' >> ~/.xinitrc
mkdir -p ~/.vimfiles

# Setup auto google
cat >> ~/.cfiles/Googleit.py << 'EOF'
import os, sys, subprocess

subprocess.Popen(['google-chrome-stable', 'http://www.google.com/search?q='+ 
                 ' '.join(sys.argv[1:]), ' &'])

EOF

chmod guo+x ~/.cfiles/Googleit.py
cp ~/.cfiles/Googleit.py ~/.pyfiles/
cp ~/.cfiles/Googleit.py ~/.vimfiles/

# Get backgrounds
wget -O ~/Pictures/winter1.jpg http://wallpaperim.net/_data/i/upload/2014/09/23/20140923661374-3acd5e08-me.jpg
wget -O ~/Pictures/winter2.jpg https://cache.desktopnexus.com/wallpapers/391/391188-1920x1080-beautiful-winter-landscape-1920x1080-wallpaper-568.jpg
wget -O ~/Pictures/winter3.jpg http://www.bhmpics.com/walls/dead_snow_winter-other.jpg
wget -O ~/Pictures/winter4.jpg https://wallpapercave.com/wp/0sCOQyE.jpg
wget -O ~/Pictures/winter5.jpg https://wallpapercave.com/wp/mc5kprj.jpg
wget -O ~/Pictures/winter6.jpg https://wallpapercave.com/wp/jNHBSir.jpg
wget -O ~/Pictures/winter7.jpg https://images.alphacoders.com/727/727275.png
wget -O ~/Pictures/winter8.jpg https://images.unsplash.com/photo-1482358625854-d7d631ba1858?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80
wget -O ~/Pictures/winter9.jpg http://www.wallpaperstop.com/wallpapers/nature-wallpapers/winter-wallpapers/winter-candle-1920x1200-164125.jpg
wget -O ~/Pictures/winter10.jpg http://wallpaperswide.com/download/winter_cat-wallpaper-1920x1080.jpg
wget -O ~/Pictures/winter11.jpg https://images4.alphacoders.com/184/thumb-1920-184306.jpg
wget -O ~/Pictures/winter12.jpg https://images5.alphacoders.com/354/thumb-1920-354500.jpg
wget -O ~/Pictures/winter13.jpg https://latestwallpapershd.com/wp-content/uploads/2019/03/Beautiful-winter-wallpaper-HD.jpg
wget -O ~/Pictures/winter14.jpg https://animal-wallpaper.com/wallpaper/winter-wallpaper-desktop-background-For-Background-HD-Wallpaper.jpg

# Opens vim, installs the plugins, then quits back to shell
vim +PlugInstall +qa

# Install a decent browser
./Chrome_Setup.sh

# install diagrams.net
sudo snap install drawio

source ~/.bashrc
