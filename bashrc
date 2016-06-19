#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias nvimless="/usr/share/nvim/runtime/macros/less.sh"
alias reddit="title \"\$(rtv --version)\" && PAGER=mkd-w3m rtv"
alias yt="i3-msg 'mark mpsyt' 1>/dev/null && mpsyt"
source /usr/share/bashmarks/bashmarks.sh
source ~/commands.sh

eval $(dircolors ~/.dircolors)
