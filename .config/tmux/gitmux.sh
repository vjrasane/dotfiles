#!/bin/bash

local path="$1"
if command -v git &>/dev/null; then
  cd "$path"
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    gitmux -cfg $HOME/.config/tmux/.gitmux.conf "$path"
  fi
fi
