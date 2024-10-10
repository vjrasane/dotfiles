#!/bin/bash

set -e

echo "#######################################################"
echo "# Installing requirements"
echo "#######################################################"

ubuntu_install() {
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible
sudo apt install -y curl
}

macos_install() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
 echo >> ~/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
 
  brew install ansible
  brew install curl
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  ubuntu_install
elif [[ "$OSTYPE" == "darwin"* ]]; then
  macos_install
fi

repo="https://github.com/vjrasane/dotfiles"
get_file_from_repo() {
  local path="$1"
  local output="$2"
  curl -fsSL "$repo"/raw/main/"$path" >"$output"
}

echo "#######################################################"
echo "# Fetching files"
echo "#######################################################"

playbook=/tmp/bootstrap-playbook.yml
get_file_from_repo bootstrap/bootstrap-playbook.yml "$playbook"

echo "#######################################################"
echo "# Running Ansible"
echo "#######################################################"

ansible-playbook --connection=local --inventory 127.0.0.1, "$playbook" --ask-become-pass
