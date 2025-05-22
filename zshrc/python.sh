if [[ -d "$HOME/.pyenv" ]]; then
	export PYENV_DIR="$HOME/.pyenv"
	[[ -d "$PYENV_DIR" ]] || { curl https://pyenv.run | bash }
	export PATH="$PYENV_DIR/bin:$PATH"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi
