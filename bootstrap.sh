#!/bin/sh

# variables
backup_dir='old_dotfiles'
files='.zshrc .vimrc .config'

# backup current dotfiles
cd $HOME
mkdir -p $backup_dir
cp -r $files $backup_dir

# copy repo contents
cd -
cp -r $files $HOME
