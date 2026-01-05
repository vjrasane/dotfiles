#!/bin/bash

if command -v keychain >/dev/null; then
  eval $(keychain --eval --quiet id_rsa)
fi
