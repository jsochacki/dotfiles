call plug#begin('~/.local/share/nvim/plugged')

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
" Enables automatic fixing of miss-spelled words under cursor
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Get Utilisnip plugin for snippits
Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" Get Colorschemes
Plug 'flazz/vim-colorschemes'

" Matching plugin
Plug 'https://github.com/adelarsq/vim-matchit'

" Verilog and SystemVerilog plugin
Plug 'vhda/verilog_systemverilog.vim'

Plug 'dense-analysis/ale'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'dhananjaylatkar/cscope_maps.nvim'

" Initialize plugin system
call plug#end()

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
set backspace=indent,eol,start
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
set number
" Turn on column numbers
set ruler
" Enable mouse
set mouse=a
"set ttymouse=sgr
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
"set smartindent
set cindent

" turn off preview window
set completeopt-=preview

"
colorscheme molokai

" Add long list of very custom vim options here

" Automatic view saving
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set viewoptions=cursor,folds,slash,unix

if !exists("g:autosave_view")
    let g:autosave_view = 0
endif

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
nnoremap <C-P> :call Toggle_transparent_background()<CR>

" remap for normal mode
nnoremap j h
nnoremap k j
nnoremap l k
nnoremap ; l

" remap for operator-pending mode
onoremap j h
onoremap k j
onoremap l k
onoremap ; l

" remap for visual select mode
xnoremap j h
xnoremap k j
xnoremap l k
xnoremap ; l

" remap for folding commands in normal mode
nnoremap zj zh
nnoremap zk zj
nnoremap zl zk
nnoremap z: zl

" Remap window traversal to match movement keys above
nnoremap <C-w>j <C-w>h
nnoremap <C-w>k <C-w>j
nnoremap <C-w>l <C-w>k
nnoremap <C-w>; <C-w>l

" Remap window movements to match movement keys above
nnoremap <C-w>J <C-w>H
nnoremap <C-w>K <C-w>J
nnoremap <C-w>L <C-w>K
nnoremap <C-w>: <C-w>L

" Get the directory of the current .vimrc.custom file
let vimrc_dir = expand('<sfile>:p:h')

" Construct the path relative to the .vimrc.custom file
let cscope_file = vimrc_dir . '/cscope/cscope_maps.nvim'

" Resolve in case it is a symbolic link
let resolved_cscope_file = resolve(cscope_file)

" Configure cscope_maps plugin using Lua
lua << EOF
require('cscope_maps').setup({
    disable_maps = false, -- Set to true if you don't want default mappings
    cscope = {
        db_file = "./cscope.out",  -- Path to the cscope database
        exec = "cscope",           -- The cscope executable
        picker = "quickfix",       -- Where search results appear (quickfix, loclist, etc.)
        qf_window_size = 10,
    },
    skip_input_prompt = false
})
EOF

if filereadable(resolved_cscope_file)
    execute 'source ' . resolved_cscope_file
endif

