copy() {
	echo -n "$1" | xclip -selection clipboard -i
}

title() {
	echo -ne "\033]2;$1\007"
}

unread() {
	if (( $# > 0 )); then
		(tmsu untagged "$1" | grep 'cbz$' || tmsu files readlater -p "$1") | \
			sort --version-sort
	else
		(tmsu untagged | grep 'cbz$' || tmsu files readlater) | \
			sort --version-sort
	fi
}

readnew() {
	tmsu untagged | grep -E 'cbz$|cbr$' | sort --version-sort | \
		xargs -d'\n' mcomix >&/dev/null &
}

alias read="xargs -d'\n' mcomix >&/dev/null"
alias readall="find . -type f | sort --version-sort | xargs -d'\n' mcomix"
