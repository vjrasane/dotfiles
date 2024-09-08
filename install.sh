#!/bin/bash

sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

ansible-playbook --connection=local --inventory 127.0.0.1, playbook.yml --ask-become-pass
