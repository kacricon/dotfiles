.PHONY: all bootstrap rebuild update_nixpkgs upgrade apply_dotfiles restore_backup ralph

BACKUP_DIR := $(HOME)/dotfiles_backup
FILES := .zshrc .config
NIX_DIR := $(HOME)/projects/dotfiles/nix
NIX_FLAKE := $(NIX_DIR)\#laptop

all: rebuild apply_dotfiles

bootstrap:
	bash setup.sh

rebuild:
	sudo darwin-rebuild switch --flake $(NIX_FLAKE)

update_nixpkgs:
	nix flake update nixpkgs --flake $(NIX_DIR)

upgrade: update_nixpkgs rebuild

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

restore_backup:
	@echo "Restoring backup..."
	@for FILE in $(FILES); do \
	  if [ -e "$(BACKUP_DIR)/$$FILE" ]; then \
	    cp -r "$(BACKUP_DIR)/$$FILE" $(HOME); \
	  else \
	    echo "Warning: Backup for $$FILE does not exist."; \
	  fi \
	done

ralph:
	bash scripts/ralph-loop.sh
