copy() {
	echo -n "$1" | xclip -selection clipboard -i
}

mkd-less() {
	pandoc -f markdown -t man $1 | sed -e 's/.PP/\n.PP/g' | man -P less -l -
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
alias mkd-w3m="pandoc -f markdown -t html | w3m -T text/html"
alias readall="find . -type f | sort --version-sort | xargs -d'\n' mcomix"
