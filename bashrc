#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion
complete -r vim

alias ls='ls --color=auto'
alias vim='vim --servername VIM'
PS1='[\u@\h \W]\$ '

alias vimless="/usr/share/vim/vim80/macros/less.sh"
alias nvimless="/usr/share/nvim/runtime/macros/less.sh"
alias reddit="PAGER=mkd-w3m rtv"
alias yt="i3-msg 'mark mpsyt' 1>/dev/null && mpsyt"
source /usr/share/bashmarks/bashmarks.sh
source ~/commands.sh

eval $(dircolors ~/.dircolors)
