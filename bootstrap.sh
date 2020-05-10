#!/bin/sh
cd ./.vim && ./update-colors.sh
mkdir -p ~/.config
ln -s ~/.vim ~/.config/nvim
