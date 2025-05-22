export FZF_COMPLETION_TRIGGER="**"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS=' --height=40% --preview="bat --color=always {}" --preview-window=right:60%:wrap'
export FZF_CTRL_R_OPTS="--height 50% --preview 'echo {2..} | bat --color=always -pl sh' --preview-window=down:5:wrap"

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

[[ -s ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -s ~/docker-fzf/docker-fzf.zsh ]] && source ~/docker-fzf/docker-fzf.zsh
[[ -s ~/fzf-git/fzf-git.sh ]] && source ~/fzf-git.sh/fzf-git.sh

source <(fzf --zsh)
