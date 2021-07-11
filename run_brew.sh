#!/bin/sh

##### install applications #####
# update Homebrew
brew update

# install all our dependencies with bundle (see brewfile)
brew tap homebrew/bundle
brew bundle

##### final configurations #####
# install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# initialize conda
conda init zsh
