#!/bin/sh

backup_dir='old_dotfiles'
files='.zshrc .config'

cd $HOME
mkdir -p $backup_dir
cp -r $files $backup_dir

cd -
cp -r $files $HOME
