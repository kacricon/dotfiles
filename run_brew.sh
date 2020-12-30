#!/bin/sh

##### install applications #####
# update Homebrew
brew update

# install all our dependencies with bundle (see brewfile)
brew tap homebrew/bundle
brew bundle

##### final configurations #####
conda init zsh
