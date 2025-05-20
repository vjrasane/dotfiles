#!/usr/bin/env bash

dotfiles_dir="$HOME/.dotfiles"
dotfiles_repo_path="vjrasane/.dotfiles"
dotfiles_repo_https="https://github.com/$dotfiles_repo_path"

{
  sudo apt update

  sudo apt install -y \
    git stow libssl-dev zsh ripgrep gcc build-essential curl ca-certificates gpg gnupg lsb-release zip unzip systemd podman vim bat fd-find python3-dev python3-pip python3-setuptools tmux net-tools pipx ruby-dev jq trash-cli neofetch

  git clone "$dotfiles_repo_https" "$dotfiles_dir"

  cd $(mktemp -d)
  wget https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz
  tar xzf nvim-linux-x86_64.tar.gz
  sudo mv nvim-linux-x86_64 /opt/nvim

  cd "$dotfiles_dir"
  stow .

  chsh -s $(which zsh)

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  nvm install 20.17.0


}
