#!/bin/bash

start_dir=$(pwd)

echo "Cloning fzf to ~/bin  ..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

echo ""
echo "Installing fzf ..."
~/.fzf/install
