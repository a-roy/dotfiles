#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export EDITOR=vim
#export BROWSER=qutebrowser
export BROWSER=urlmenu
export TERMINAL=termite
export PATH=$PATH:~/.local/bin:~/bin
export STEAM_FRAME_FORCE_CLOSE=1

if [ -z "$SSH_AUTH_SOCK" ]
then
	eval $(ssh-agent -s)
	ssh-add
fi

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
