export FZF_COMPLETION_TRIGGER="**"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS=' --height=40% --preview="bat --color=always {}" --preview-window=right:60%:wrap'
export FZF_CTRL_R_OPTS="--height 50% --preview 'echo {2..} | bat --color=always -pl sh' --preview-window=down:5:wrap"

# Source fzf shell integration (keybindings and completion)
source <(fzf --zsh)

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

[[ -s ~/docker-fzf/docker-fzf.zsh ]] && source ~/docker-fzf/docker-fzf.zsh
[[ -s ~/fzf-git/fzf-git.sh ]] && source ~/fzf-git.sh/fzf-git.sh

# Helper function for jj bookmark completion
_fzf_complete_jj_bookmarks() {
  _fzf_complete --prompt="Bookmarks> " --preview='jj log -r ::{} --color=always 2>/dev/null' --preview-window='right:50%:wrap,<80(down:50%:wrap)' -- "$@" < <(
    jj bookmark list --sort committer-date- --template 'name ++ if(remote, "@" ++ remote, "") ++ "\n"'
  )
}

# Custom fzf completion for jj bookmarks
_fzf_complete_jj() {
  local tokens lbuf
  lbuf="$1"
  tokens=(${(z)lbuf})

  # Check if we're in a bookmark subcommand (jj bookmark set/delete/rename/forget/track/untrack)
  if [[ "${tokens[2]}" == "bookmark" ]]; then
    _fzf_complete_jj_bookmarks "$@"
    return
  fi

  # Check if previous token is --bookmark or -b
  if [[ "${tokens[-1]}" == "--bookmark" ]] || [[ "${tokens[-1]}" == "-b" ]] || [[ "${tokens[-1]}" == "-r" ]] || [[ "${tokens[-1]}" == "--revisions" ]]; then
    _fzf_complete_jj_bookmarks "$@"
    return
  fi

  # Otherwise, use default fzf file completion
  _fzf_path_completion "$prefix" "$lbuf"
}

# Post-completion handler to insert the selected bookmark
_fzf_complete_jj_post() {
  awk '{print $1}'
}
