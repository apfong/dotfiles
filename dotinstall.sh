#!/bin/bash
# Installation script for vim dotfiles
cp vim/.vim ~
cp vim/.vimrc ~
cp tmux/.tmux.conf ~
cp git/.gitconfig ~
cp .zshrc ~
cp .ripgreprc ~
cp .rgignore ~

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
sleep 1
vim -c 'PluginInstall'
