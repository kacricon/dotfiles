.PHONY: all install_packages apply_dotfiles install_brew configure_macos restore_backup

BREW := /opt/homebrew/bin/brew
BACKUP_DIR := $(HOME)/dotfiles_backup
FILES := .zshrc .config

all: install_packages apply_dotfiles configure_macos

install_brew:
	@if ! which brew > /dev/null; then \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		touch "$$HOME/.zprofile"; \
		echo 'eval "$$($(BREW) shellenv)"' >> "$$HOME/.zprofile"; \
		eval "$$($(BREW) shellenv)"; \
	fi

install_packages: install_brew
	@echo "Installing packages using Homebrew..."
	@$(BREW) update
	@$(BREW) tap homebrew/bundle
	@$(BREW) bundle

apply_dotfiles:
	@echo "Backing up current dotfiles..."
	@mkdir -p $(BACKUP_DIR)
	@for FILE in $(FILES); do \
	  if [ -e "$(HOME)/$$FILE" ]; then \
	    cp -r "$(HOME)/$$FILE" $(BACKUP_DIR); \
	  else \
	    echo "Warning: $$FILE does not exist."; \
	  fi \
	done
	@echo "Applying new dotfiles..."
	@cp -r $(FILES) $(HOME)

configure_macos:
	@echo "Configuring MacOS..."
	@defaults write com.apple.dock appswitcher-all-displays -bool true # make app switcher show up on all displays
	@killall Dock

restore_backup:
	@echo "Restoring backup..."
	@for FILE in $(FILES); do \
	  if [ -e "$(BACKUP_DIR)/$$FILE" ]; then \
	    cp -r "$(BACKUP_DIR)/$$FILE" $(HOME); \
	  else \
	    echo "Warning: Backup for $$FILE does not exist."; \
	  fi \
	done
