# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ! -f ~/antigen.zsh ]]; then
  curl -L git.io/antigen > ~/antigen.zsh
fi

source ~/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle aliases
antigen bundle command-not-found
antigen bundle z
antigen bundle fzf
# antigen bundle docker
# antigne bundle nvm  
# antigen bundle manlao/zsh-auto-nvm
antigen bundle zsh-users/zsh-syntax-highlighting
 
antigen theme romkatv/powerlevel10k
# antigen theme robbyrussell

antigen apply


# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

EDITOR=nvim

source ~/.fzfrc

# nvm
if [[ -d "$HOME/.nvm" ]]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# bun
if [[ -d "$HOME/.bun" ]]; then
	export BUN_INSTALL="$HOME/.bun"
	export PATH=$BUN_INSTALL/bin:$PATH
fi

# cargo
if [[ -d "$HOME/.cargo" ]]; then
	export PATH=$HOME/.cargo/bin:$PATH
fi

if [[ -d "$HOME/.pyenv" ]]; then
	export PYENV_DIR="$HOME/.pyenv"
	[[ -d "$PYENV_DIR" ]] || { curl https://pyenv.run | bash }
	export PATH="$PYENV_DIR/bin:$PATH"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="$PATH:/opt/nvim-linux64/bin"
