let s:Unix = has("unix")
let s:Linux = system("uname") == "Linux\n"
let s:MSWindows = has("win32") || has("win64")
let s:Cygwin = has("win32unix")
let s:Nvim = has("nvim")

let vimdir = split(&rtp, ',')[0]

if s:Nvim
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
endif

set nocompatible

" {{{ Vim-plug
if empty(glob(vimdir . '/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin(vimdir . '/plugged')

" {{{ GUI
Plug 'jonathanfilip/vim-lucius'
Plug 'iissnan/tangoX'
Plug 'kien/rainbow_parentheses.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" }}} GUI
" {{{ General Editing
Plug 'xolox/vim-misc'
Plug 'xolox/vim-shell'
Plug 'Lokaltog/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-surround'
Plug 'myusuf3/numbers.vim'
Plug 'Konfekt/FastFold'
if s:Nvim
Plug 'Shougo/deoplete.nvim'
let g:deoplete#enable_at_startup = 1
else
Plug 'Shougo/neocomplete.vim'
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#force_omni_input_patterns')
	let g:neocomplete#force_omni_input_patterns = {}
endif

let g:neocomplete#force_omni_input_patterns.c =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:neocomplete#force_omni_input_patterns.cpp =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
endif
Plug 'justmao945/vim-clang'
let g:clang_cpp_options = '-std=gnu++11 -x c++'
let g:clang_verbose_pmenu = 1
" }}} General Editing
" {{{ File Management
Plug 'Shougo/vimproc.vim'
Plug 'Shougo/unite.vim'
" }}} File Management
" {{{ Version Control
Plug 'tpope/vim-fugitive'
" }}} Version Control
" {{{ Markdown
if s:Nvim
"Plug 'rhysd/nyaovim-markdown-preview'
"let g:markdown_preview_auto=1
"let g:markdown_preview_eager=1
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    !cargo build --release
    UpdateRemotePlugins
  endif
endfunction

Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
let g:markdown_composer_browser = 'vimb'
elseif s:Unix
Plug 'suan/vim-instant-markdown'
elseif s:MSWindows
Plug 'euclio/vim-instant-markdown'
endif
" }}} Markdown
" {{{ LaTeX
" TODO get something to work, and also not occupy key bindings
"Plug 'git://git.code.sf.net/p/vim-latex/vim-latex'
"Plug 'coot/atp_vim'
Plug 'LaTeX-Box-Team/LaTeX-Box', { 'for': ['latex'] }
" }}} LaTeX
" {{{ Coding
" {{{ General
Plug 'majutsushi/tagbar'
"Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdcommenter'
if !s:Nvim
	Plug 'rosenfeld/conque-term'
endif
Plug 'glsl.vim'
" }}} General
" {{{ Lisp/Scheme
Plug 'kovisoft/slimv'
" }}} Lisp/Scheme
" {{{ C/C++
"Plug 'refactor'
" http://cscope.sourceforge.net/cscope_vim_tutorial.html
" http://www.vim.org/scripts/script.php?script_id=2087
" http://www.vim.org/scripts/script.php?script_id=2699
" http://www.reddit.com/r/vim/comments/e99h9/is_there_a_way_to_change_the_way_and_move/c16duif
" https://code.google.com/p/lh-vim/wiki/lhCpp
" }}} C/C++
if s:Nvim
Plug 'bfredl/nvim-ipy'
endif
" }}} Coding

call plug#end()
" }}} Vim-plug
" {{{ Configuration
" {{{ Global settings

" Visual aids
set number relativenumber
set ruler
set hlsearch
set laststatus=2
set noshowmode
execute "set colorcolumn=+" . join(range(1,255), ',+')

" Cusor shapes in terminal
" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
if s:Cygwin
	let &t_ti .= "\e[1 q"
	let &t_SI .= "\e[5 q"
	let &t_SR .= "\e[3 q"
	let &t_EI .= "\e[1 q"
	let &t_te .= "\e[0 q"
elseif &term =~ '^xterm\|rxvt'
	let &t_SI .= "\<Esc>[5 q"
	let &t_SR .= "\<Esc>[3 q"
	let &t_EI .= "\<Esc>[1 q"
endif
if !has("gui_running")
	set ttimeoutlen=0
endif

" Set color scheme
if s:Nvim
	colorscheme tangoX
	highlight ColorColumn guibg=WhiteSmoke
else
	colorscheme lucius
	LuciusWhite
endif

" Tab options
set tabstop=4 noexpandtab shiftwidth=4 softtabstop=4

" Folding options
set foldmethod=syntax foldminlines=4

" Backspace behavior
set backspace=indent,eol,start

" Allow modified buffers to be hidden
set hidden

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
let g:airline#extensions#tagbar#enabled = 1
" Some airline themes copy colors from the active colorscheme:
" hybrid, lucius, monochrome, tomorrow, zenburn
let g:airline_theme = "zenburn"
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

if s:Nvim
	augroup vimrc_aucmd
		autocmd!
    	autocmd CursorHold * rshada|wshada
	augroup END
endif

" Turn on word wrapping
autocmd BufRead,BufNewFile *.txt,*.tex
	\ set wrap linebreak nolist textwidth=0 wrapmargin=0

" Auto-compile when saving
"autocmd BufWritePost *.tex silent call Tex_RunLaTeX()
"autocmd BufWritePost *.tex silent !pkill -USR1 xdvi.bin
autocmd FileType tex set textwidth=80
autocmd FileType c,cpp set comments^=://!
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
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
map  B :Unite buffer file/async -smartcase<CR>
" F5 : implemented per filetype
nmap <F7>   :TagbarToggle<CR>
map  <C-CR> :Open<CR>
" F8 : ConqueTerm_ToggleKey
" F9 : ConqueTerm_SendVisKey
" F10 : ConqueTerm_SendFileKey
" F11 : ConqueTerm_ExecFileKey

inoremap <C-B> <Left>
inoremap <C-F> <Right>
inoremap <C-D> <Del>
inoremap <C-BS> <C-W>
" }}} Custom keybindings
" }}} Configuration
