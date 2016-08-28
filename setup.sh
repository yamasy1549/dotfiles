#!/bin/bash

DOT_FILES=(.bash_profile .bashrc .git .gitconfig .tmux.conf .vim .vimrc .zshrc)

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done
