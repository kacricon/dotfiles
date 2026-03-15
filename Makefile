.PHONY: all apply_dotfiles configure_macos restore_backup

BACKUP_DIR := $(HOME)/dotfiles_backup
FILES := .zshrc .config

all: apply_dotfiles configure_macos

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
	@echo "macOS preferences are now managed by nix-darwin system.defaults in nix/flake.nix"
	@echo "Run: sudo darwin-rebuild switch --flake ~/projects/dotfiles/nix#laptop"

restore_backup:
	@echo "Restoring backup..."
	@for FILE in $(FILES); do \
	  if [ -e "$(BACKUP_DIR)/$$FILE" ]; then \
	    cp -r "$(BACKUP_DIR)/$$FILE" $(HOME); \
	  else \
	    echo "Warning: Backup for $$FILE does not exist."; \
	  fi \
	done
