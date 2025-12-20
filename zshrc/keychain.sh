#!/bin/bash

if command -v keychain >/dev/null; then
  eval $(keychain --eval --quiet --agents ssh id_rsa)
fi
