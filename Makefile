.PHONY: all bootstrap rebuild update_nixpkgs upgrade apply_dotfiles restore_backup ralph

BACKUP_DIR := $(HOME)/dotfiles_backup
DOTFILES := .zshrc
CONFIG_DIRS := nvim kitty yazi
NIX_DIR := $(HOME)/projects/dotfiles/nix
NIX_FLAKE := $(NIX_DIR)\#laptop
DARWIN_REBUILD_PACKAGE := $(NIX_DIR)\#darwin-rebuild

all: rebuild apply_dotfiles

bootstrap:
	sh setup.sh

rebuild:
	@if command -v darwin-rebuild >/dev/null 2>&1; then \
	  sudo "$$(command -v darwin-rebuild)" switch --flake "$(NIX_FLAKE)"; \
	else \
	  sudo "$$(command -v nix)" --extra-experimental-features 'nix-command flakes' run "$(DARWIN_REBUILD_PACKAGE)" -- switch --flake "$(NIX_FLAKE)"; \
	fi

update_nixpkgs:
	nix flake update nixpkgs --flake $(NIX_DIR)

upgrade: update_nixpkgs rebuild

apply_dotfiles:
	@echo "Backing up current dotfiles..."
	@mkdir -p "$(BACKUP_DIR)" "$(BACKUP_DIR)/.config" "$(HOME)/.config"
	@for FILE in $(DOTFILES); do \
	  if [ -e "$(HOME)/$$FILE" ]; then \
	    if [ -e "$(BACKUP_DIR)/$$FILE" ]; then \
	      echo "Backup already exists for $$FILE; leaving it unchanged."; \
	    else \
	      rsync -a "$(HOME)/$$FILE" "$(BACKUP_DIR)/$$FILE"; \
	    fi; \
	  else \
	    echo "Warning: $$FILE does not exist."; \
	  fi \
	done
	@for DIR in $(CONFIG_DIRS); do \
	  if [ -e "$(HOME)/.config/$$DIR" ]; then \
	    if [ -e "$(BACKUP_DIR)/.config/$$DIR" ]; then \
	      echo "Backup already exists for .config/$$DIR; leaving it unchanged."; \
	    else \
	      mkdir -p "$(BACKUP_DIR)/.config/$$DIR"; \
	      rsync -a "$(HOME)/.config/$$DIR/" "$(BACKUP_DIR)/.config/$$DIR/"; \
	    fi; \
	  else \
	    echo "Warning: .config/$$DIR does not exist."; \
	  fi \
	done
	@echo "Applying new dotfiles..."
	@for FILE in $(DOTFILES); do \
	  rsync -a "$$FILE" "$(HOME)/$$FILE"; \
	done
	@for DIR in $(CONFIG_DIRS); do \
	  mkdir -p "$(HOME)/.config/$$DIR"; \
	  rsync -a --delete ".config/$$DIR/" "$(HOME)/.config/$$DIR/"; \
	done

restore_backup:
	@echo "Restoring backup..."
	@for FILE in $(DOTFILES); do \
	  if [ -e "$(BACKUP_DIR)/$$FILE" ]; then \
	    rsync -a "$(BACKUP_DIR)/$$FILE" "$(HOME)/$$FILE"; \
	  else \
	    echo "Warning: Backup for $$FILE does not exist."; \
	  fi \
	done
	@for DIR in $(CONFIG_DIRS); do \
	  if [ -e "$(BACKUP_DIR)/.config/$$DIR" ]; then \
	    mkdir -p "$(HOME)/.config/$$DIR"; \
	    rsync -a --delete "$(BACKUP_DIR)/.config/$$DIR/" "$(HOME)/.config/$$DIR/"; \
	  else \
	    echo "Warning: Backup for .config/$$DIR does not exist."; \
	  fi \
	done

ralph:
	bash scripts/ralph-loop.sh
