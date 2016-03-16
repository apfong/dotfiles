#!/bin/bash
# Installation script for vim dotfiles
mv .vim ~
mv .vimrc ~

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
sleep 1
vim -c 'PluginInstall'

rm -rf ../dotfiles
