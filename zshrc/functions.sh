# Searches for text in all files in the current folder
ftext() {
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

f() {
	# local search="$1"
	#
	# 	# Run search using rg and fzf
	local selected
	# 	IFS=: read -ra selected < <(rg --with-filename --line-number --no-heading --color=never -L \
	#     "$search" . 2>/dev/null | fzf --ansi \
	# 			--delimiter ':' \
	#       --preview '
	# FILE=$(echo {} | cut -d: -f1); LINE=$(echo {} | cut -d: -f2);
	# START=$((LINE > 10 ? LINE - 10 : 0));
	# bat --style=numbers --color=always --highlight-line $LINE --line-range "$START:" $FILE' \
	#
	IFS=: read -rA selected < <(
		rg --color=always --line-number --no-heading --smart-case -L "${*:-}" 2>/dev/null |
			fzf --ansi \
				--color "hl:-1:underline,hl+:-1:underline:reverse" \
				--delimiter : \
				--preview 'bat --color=always {1} --highlight-line {2}' \
				--preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
	)

	[ -n "${selected[0]}" ] && "$EDITOR" "${selected[0]}" "+${selected[1]}"
	# if [[ -s "$result" ]]; then
	# 	local file line
	#    read -r file line _ < <(curt -d: -f1-2 "$result")
	# 	# file=$(echo "$result" | cut -d: -f1)
	# 	# line=$(echo "$result" | cut -d: -f2)
	# 	"$EDITOR" "+$line" "$file"
	# fi
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip() {
	# Internal IP Lookup.
	if command -v ip &>/dev/null; then
		echo -n "Internal IP: "
		ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
	else
		echo -n "Internal IP: "
		ifconfig wlan0 | grep "inet " | awk '{print $2}'
	fi

	# External IP Lookup
	echo -n "External IP: "
	curl -s ifconfig.me
}

sshkeys() {
	for keyfile in ~/.ssh/*.pub; do
		[ -f "$keyfile" ] || continue
		echo "=== $(basename "$keyfile") ==="
		cat "$keyfile"
		echo
	done
}

portkill() {
	port=$1
	echo "Killing processes on port $port..."
	lsof -ti:$port | xargs kill -9 2>/dev/null && echo "Killed" || echo "No processes found on port $port"
}

# List jj workspace candidates (ws-* dirs) in the current dir and the current repo's parent
_ws_candidates() {
	local -a roots
	local -A seen
	local root r dir
	roots=("$PWD")
	root=$(jj workspace root 2>/dev/null) && roots+=("${root:h}")
	for r in $roots; do
		for dir in $r/ws-*(N/); do
			[[ -e $dir/.jj && -z ${seen[$dir]} ]] || continue
			seen[$dir]=1
			print -r -- "$dir"
		done
	done
}

# Fuzzy-switch to a jj workspace (ws-* sibling dirs) near the current location,
# falling back to zoxide (cd) with the raw query when nothing matches
ws() {
	local -a cands
	cands=(${(f)"$(_ws_candidates)"})
	local t ret
	if (( ${#cands} )); then
		t=$(print -rl -- $cands | fzf -q "${*:-}" --select-1 --exit-0 --delimiter / --nth -1 \
			--preview 'jj --ignore-working-copy -R {} log --limit 5 --color=always')
		ret=$?
		[[ -n $t ]] && { cd "$t"; return }
		(( ret == 130 )) && return $ret
	fi
	(( $# )) && cd "$@"
}
