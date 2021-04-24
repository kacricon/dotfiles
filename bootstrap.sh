#!/bin/sh

##### variables #####
backup_dir='old_dotfiles'
files='.zshrc .config'

##### install applications #####
# check for Homebrew and install it if not found
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

##### apply dotfiles #####
# backup current dotfiles
cd $HOME
mkdir -p $backup_dir
cp -r $files $backup_dir

# copy repo contents
cd -
cp -r $files $HOME

##### final touches #####
# start conda
conda init zsh
