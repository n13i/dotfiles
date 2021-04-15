#!/bin/sh
cd ./.vim && ./update-colors.sh
mkdir -p ~/.config
ln -s ~/.vim ~/.config/nvim

wget -O ~/.git-prompt.sh https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh

