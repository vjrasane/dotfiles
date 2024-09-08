#!/bin/bash

sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

sudo apt install -y curl

get_file_from_repo() {
  local path="$1"
  local output="$2"
  curl -fsSL https://github.com/vjrasane/dotfiles/raw/main/"$path" >"$output"
}

playbook=/tmp/playbook.yml
get_file_from_repo playbook.yml "$playbook"

ansible-playbook --connection=local --inventory 127.0.0.1, "$playbook" --ask-become-pass
