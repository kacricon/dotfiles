.PHONY: all install_packages apply_dotfiles

backup_dir := $(HOME)/old_dotfiles
files := .zshrc .config

all: install_packages apply_dotfiles

install_packages:
	@if ! which brew > /dev/null; then \
		echo "Installing Homebrew..."; \
		/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@echo "Installing packages using Homebrew..."
	@brew update
	@brew tap homebrew/bundle
	@brew bundle

apply_dotfiles:
	@echo "Backing up current dotfiles..."
	@mkdir -p $(backup_dir)
	@for file in $(files); do \
	  if [ -e "$(HOME)/$$file" ]; then \
	    cp -r "$(HOME)/$$file" $(backup_dir); \
	  else \
	    echo "Warning: $$file does not exist."; \
	  fi \
	done
	@echo "Applying new dotfiles..."
	@cp -r $(files) $(HOME)
