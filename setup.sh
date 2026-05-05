#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/projects/dotfiles"
REPO_URL="https://github.com/jrc/dotfiles.git"

info() { printf '\033[1;34m==> %s\033[0m\n' "$1"; }
ok()   { printf '\033[1;32m==> %s\033[0m\n' "$1"; }
warn() { printf '\033[1;33m==> %s\033[0m\n' "$1"; }

# 1. Xcode Command Line Tools
info "checking xcode command line tools..."
if xcode-select -p &>/dev/null; then
  ok "xcode command line tools already installed"
else
  info "installing xcode command line tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  ok "xcode command line tools installed"
fi

# 2. Nix (Determinate Systems installer)
info "checking nix..."
if command -v nix &>/dev/null; then
  ok "nix already installed"
else
  info "installing nix via determinate systems installer..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  # Source nix in current shell
  if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
  ok "nix installed"
fi

# 3. Clone or update dotfiles repo
info "checking dotfiles repo..."
if [ -d "$DOTFILES_DIR/.git" ]; then
  info "dotfiles repo exists, pulling latest..."
  git -C "$DOTFILES_DIR" pull --ff-only || warn "git pull failed, continuing with existing state"
  ok "dotfiles repo up to date"
else
  info "cloning dotfiles repo..."
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone "$REPO_URL" "$DOTFILES_DIR"
  ok "dotfiles repo cloned"
fi

# 4. Nix-darwin rebuild
info "running darwin-rebuild switch..."
sudo darwin-rebuild switch --flake "$DOTFILES_DIR/nix#laptop"
ok "darwin-rebuild complete"

# 5. Apply dotfiles
info "applying dotfiles..."
make -C "$DOTFILES_DIR" apply_dotfiles
ok "dotfiles applied"

ok "bootstrap complete"

echo ""
echo "┌─────────────────────────────────────────────┐"
echo "│          Post-bootstrap checklist            │"
echo "├─────────────────────────────────────────────┤"
echo "│ □ Set git identity:                         │"
echo "│   git config --global user.name \"Your Name\" │"
echo "│   git config --global user.email \"you@…\"    │"
echo "│ □ Install Bitwarden extension in browser    │"
echo "│ □ Set default browser                       │"
echo "└─────────────────────────────────────────────┘"
