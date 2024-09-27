#!/bin/bash

path="$1"
[[ "$path" =~ ^"$HOME"(/|$) ]] && path="~${path#$HOME}"
echo "$path"
