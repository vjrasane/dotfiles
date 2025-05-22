if [[ -d "$HOME/.nvm" ]] ; then
  export NVM_DIR="$HOME/.nvm"
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  elif [[ "$OSTYPE" == "darwin"* ]]; then
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
  fi
fi

if [[ -d "$HOME/.bun" ]] ; then 
  # bun completions
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

  export BUN_INSTALL="$HOME/.bun"
  export PATH=$BUN_INSTALL/bin:$PATH
fi
