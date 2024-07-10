# Makefile to manage dotfiles

SCRIPTS := install_packages.sh apply_dotfiles.sh

.PHONY: all make_executable install_packages apply_dotfiles

all: install_packages apply_dotfiles

make_executable:
	@for script in $(SCRIPTS); do \
		if [ ! -x "$$script" ]; then \
			chmod +x "$$script"; \
		fi \
	done

install_packages: make_executable
	@echo "Installing packages using Homebrew..."
	@./install_packages.sh

apply_dotfiles: make_executable
	@echo "Copying dotfiles..."
	@./apply_dotfiles.sh
