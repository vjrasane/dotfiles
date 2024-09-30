#!/bin/bash

echo "#######################################################"
echo "# Installing requirements"
echo "#######################################################"

sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible
sudo apt install -y curl

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
