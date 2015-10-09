let s:Unix = has("unix")
let s:Linux = system("uname") == "Linux\n"
let s:MSWindows = has("win32") || has("win64")

" {{{ Vundle
set nocompatible              " be iMproved, required
filetype off                  " required
" Syntax highlighting
syntax on

" set the runtime path to include Vundle and initialize
if s:MSWindows
	set rtp+=~/vimfiles/bundle/Vundle.vim
	let path='~/vimfiles/bundle'
	call vundle#begin(path)
else
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()
endif

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.
" {{{ GUI
Plugin 'iissnan/tangoX'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'bling/vim-airline'
" }}} GUI
" {{{ General Editing
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-shell'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'godlygeek/tabular'
Plugin 'tpope/vim-surround'
Plugin 'myusuf3/numbers.vim'
" NOTE: See :help vimproc-install
" how does neocomplete work? I like YCM
"Plugin 'Shougo/neocomplete.vim'
"Plugin 'osyo-manga/vim-reunions'
"Plugin 'osyo-manga/vim-marching'
" }}} General Editing
" {{{ File Management
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/unite.vim'
" }}} File Management
" {{{ Version Control
Plugin 'tpope/vim-fugitive'
" }}} Version Control
" {{{ Markdown
if s:Unix
Plugin 'suan/vim-instant-markdown'
elseif s:MSWindows
Plugin 'euclio/vim-instant-markdown'
endif
" }}} Markdown
" {{{ LaTeX
" TODO get something to work, and also not occupy key bindings
"Plugin 'git://git.code.sf.net/p/vim-latex/vim-latex'
"Plugin 'coot/atp_vim'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
" }}} LaTeX
" {{{ Coding
" {{{ General
" NOTE: Requires compilation with CMake
" See :help youcompleteme-full-installation-guide
" Windows:
"   cmake -G "Visual Studio 12"
"   -DPATH_TO_LLVM_ROOT="C:\Program Files (x86)\LLVM"
"   . <USERFOLDER>\vimfiles\bundle\YouCompleteme\third_party\ycmd\cpp
" Configuration Properties -> Linker -> Additional Dependencies:
" C:\Program Files (x86)\LLVM\lib\libclang.imp
"   msbuild /t:ycm_core,ycm_client_support /property:configuration=Release
"   YouCompleteMe.sln
Plugin 'Valloric/YouCompleteMe'
Plugin 'majutsushi/tagbar'
if has("gui_running")
Plugin 'SirVer/ultisnips'
endif
"Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdcommenter'
Plugin 'rosenfeld/conque-term'
" }}} General
" {{{ Lisp/Scheme
Plugin 'kovisoft/slimv'
" }}} Lisp/Scheme
" {{{ C/C++
"Plugin 'refactor'
" http://cscope.sourceforge.net/cscope_vim_tutorial.html
" http://www.vim.org/scripts/script.php?script_id=2087
" http://www.vim.org/scripts/script.php?script_id=2699
" http://www.reddit.com/r/vim/comments/e99h9/is_there_a_way_to_change_the_way_and_move/c16duif
" https://code.google.com/p/lh-vim/wiki/lhCpp
" }}} C/C++
" }}} Coding

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
" }}} Vundle
" {{{ Configuration
" {{{ Global settings
" Maximize GUI
if s:MSWindows
autocmd GUIEnter * simalt ~x
endif

" Set font
if s:MSWindows
set guifont=Consolas:h9:cANSI
set encoding=utf-8
else
set guifont=Droid\ Sans\ Mono\ Dotted\ for\ Powerline\ 6.5
endif

" Visual aids
set number relativenumber
set ruler
set hlsearch
set laststatus=2
execute "set colorcolumn=+" . join(range(1,255), ',+')

" Hide all GUI
set guioptions-=T guioptions-=t guioptions-=L guioptions-=r guioptions-=m
set guioptions-=e

" Set color scheme
colorscheme tangoX
highlight ColorColumn guibg=WhiteSmoke

" Tab options
set tabstop=4 noexpandtab shiftwidth=4 softtabstop=4

" Folding options
set foldmethod=syntax foldminlines=4

" Backspace behavior
set backspace=indent,eol,start

" Allow modified buffers to be hidden
set hidden

cd ~
" }}} Global settings
" {{{ Plugin configuration
" {{{ shell.vim
" hide menu and toolbar but not tab bar
let g:shell_fullscreen_items='mT'
" don't force Vim on top
let g:shell_fullscreen_always_on_top = 0
" }}} shell.vim
" {{{ unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
" }}} unite
"{{{ ConqueTerm
let g:ConqueTerm_ToggleKey = '' " F8
let g:ConqueTerm_ExecFileKey = '' " F11
let g:ConqueTerm_SendFileKey = '' " F10
let g:ConqueTerm_SendVisKey = '' " F9
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_CWInsert = 1
"let g:ConqueTerm_StartMessages = 1
"}}} ConqueTerm
" {{{ Tagbar
if s:MSWindows
let g:tagbar_ctags_bin = 'C:\ctags58\ctags.exe'
endif

let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
" }}} Tagbar
" {{{ LaTeX Suite
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat = 'pdf'
if has("win32")
let g:Tex_ViewRule_pdf =
	\ 'SumatraPDF -reuse-instance -inverse-search
	\ "gvim -c \":RemoteOpen +\%l \%f\""'
let g:Tex_CompileRule_pdf =
	\ 'pdflatex -synctex=-1 -src-specials -interaction=nonstopmode $*'
endif
" }}} LaTeX Suite
" {{{ LatexBox
let g:LatexBox_latexmk_async=1
let g:LatexBox_latexmk_preview_continuously=1
" }}} LatexBox
" {{{ Automatic TeX Plugin
"autocmd BufReadPre *.tex let b:atp_TexFlavor="latex"
if s:Linux
autocmd BufReadPre *.tex let b:atp_Viewer="zathura"
endif
" }}} Automatic TeX Plugin
" {{{ Rainbow Parentheses
" options
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
" NOTE: see further configuration under Autocommands
" }}} Rainbow Parentheses
" {{{ YouCompleteMe
let g:ycm_autoclose_preview_window_after_insertion = 1
" }}} YouCompleteMe
" {{{ Syntastic
"let g:syntastic_cpp_checkers = ['gcc']
"let g:syntastic_cpp_check_header = 1
"let g:syntastic_cpp_auto_refresh_includes = 1
"let g:syntastic_cpp_compiler = 'clang++'
" }}} Syntastic
" {{{ Slimv
let g:slimv_ctags=1
" }}} Slimv
" {{{ vim-airline
" TODO powerline symbols on windows
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
if has("gui_running")
let g:airline_theme = "lucius"
else
let g:airline_theme = "understated"
endif
" }}} vim-airline
" }}} Plugin configuration
" {{{ Ex commands
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis |
		\ windmcd p | diffthis
endif
if s:MSWindows
command! L2rtf execute "!\"C:/Program Files (x86)/latex2rtf/latex2rt\" \""
	\ . bufname("%") . "\""
command! GCC :!gcc % -o %:r & %:r
command! Clang :!clang % -o %:r & %:r
command! CMake :!vcvars32 & cd build &
	\"C:\Program Files (x86)\CMake 2.8\bin\cmake-gui"
command! Python silent execute "!start py -2 -i \"" . bufname("%") . "\""
command! Python3 silent execute "!start py -3 -i \"" .bufname("%") . "\""
command! Py execute "lcd " . expand("%:h") |
	\ execute "ConqueTermSplit py -i \"" . expand("%:t") . "\""
command! Pyv execute "lcd " . expand("%:h") |
	\ execute "ConqueTermVSplit py -i \"" . expand("%:t") . "\""
command! Racket silent execute "!start racket -i -u \"" . bufname("%") . "\""
command! Rkt execute "lcd " . expand("%:h") |
	\ execute "ConqueTermSplit racket -i -u \"" . expand("%:t") . "\""
command! Rktv execute "lcd " . expand("%:h") |
	\ execute "ConqueTermVSplit racket -i -u \"" . expand("%:t") . "\""
endif
" }}} Ex commands
" {{{ Autocommands
autocmd FileType vim set foldmethod=marker foldminlines=1
autocmd FileType * normal zR

" Turn on word wrapping
autocmd BufRead,BufNewFile *.txt,*.tex
	\ set wrap linebreak nolist textwidth=0 wrapmargin=0

" Auto-compile when saving
"autocmd BufWritePost *.tex silent call Tex_RunLaTeX()
"autocmd BufWritePost *.tex silent !pkill -USR1 xdvi.bin
autocmd FileType tex set textwidth=80
autocmd FileType c,cpp set comments^=://!
" Treat Racket as Scheme
autocmd BufReadPost *.rkt,*.rktl set filetype=scheme
set lispwords+=
	\public-method,override-method,private-method,syntax-case,syntax-rules
set lispwords+=define-type,type-case
" Rainbow Parentheses
autocmd VimEnter * RainbowParenthesesActivate
autocmd ColorScheme * RainbowParenthesesActivate
autocmd Syntax * RainbowParenthesesLoadRound
autocmd Syntax * RainbowParenthesesLoadSquare

if s:MSWindows
autocmd FileType c nmap <buffer> <F5> :GCC<CR>
autocmd FileType python nmap <buffer> <F5> :Py<CR>
autocmd FileType scheme nmap <buffer> <F5> :Rkt<CR>
endif
" }}} Autocommands
" {{{ Custom keybindings
let mapleader=","

map gb :bnext<CR>
map gB :bprevious<CR>
map  B      :Unite buffer file -smartcase<CR>
" F5 : implemented per filetype
nmap <F7>   :TagbarToggle<CR>
map  <C-CR> :Open<CR>
" F8 : ConqueTerm_ToggleKey
" F9 : ConqueTerm_SendVisKey
" F10 : ConqueTerm_SendFileKey
" F11 : ConqueTerm_ExecFileKey

inoremap <C-BS> <C-W>
" }}} Custom keybindings
" }}} Configuration
