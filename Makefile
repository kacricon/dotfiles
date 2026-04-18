.PHONY: all bootstrap rebuild apply_dotfiles restore_backup ralph

BACKUP_DIR := $(HOME)/dotfiles_backup
FILES := .zshrc .config .hermes

all: rebuild apply_dotfiles

bootstrap:
	bash setup.sh

rebuild:
	sudo darwin-rebuild switch --flake ~/projects/dotfiles/nix#laptop

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
