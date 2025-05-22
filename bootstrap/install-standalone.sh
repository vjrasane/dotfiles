#!/usr/bin/env bash -e

dotfiles_dir="$HOME/.dotfiles"
dotfiles_repo_path="vjrasane/.dotfiles"
dotfiles_repo_https="https://github.com/$dotfiles_repo_path"

install_on_ubuntu () {
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

  # zsh
  chsh -s $(which zsh)

  # Nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

  # Docker
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin





}

install_on_macos () {

}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  install_on_ubuntu
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_on_ubuntu
fi
