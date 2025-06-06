
#####################################################
# SPECIAL FUNCTIONS
#####################################################
# Extracts any archive(s) (if unp isn't installed)
function extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

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
function whatsmyip () {
    # Internal IP Lookup.
    if command -v ip &> /dev/null; then
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
