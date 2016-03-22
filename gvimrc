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

" Hide all GUI
set guioptions-=T guioptions-=t guioptions-=L guioptions-=r guioptions-=m
set guioptions-=e

" Set color scheme
colorscheme tangoX
highlight ColorColumn guibg=WhiteSmoke

source $MYVIMRC.local
