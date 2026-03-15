# Packages Implementation Plan

Implementation checklist for specs/packages.md.

> Spec: [packages.md](packages.md)
> Created: 2026-03-15

## Overview

Make `nix/flake.nix` the single source of truth for all packages by deleting the legacy `Brewfile` and removing the Homebrew-based install targets from the `Makefile`. The flake already declares everything the Brewfile contains — this plan eliminates the duplication.

All packages are already in `flake.nix` (verified against both files). No changes to `flake.nix` are needed.

## File Inventory

| File | Action | Purpose |
|------|--------|---------|
| `Brewfile` | Delete | Remove legacy package declarations (all content already in flake.nix) |
| `Makefile` | Modify | Remove `install_brew` and `install_packages` targets; update `all` target |
| `specs/packages.md` | Modify | Move items from Desired State to Current State |
| `specs/README.md` | Modify | Add this plan to the implementation plans table |

## Phase 1: Delete Brewfile

> Reference: packages.md §Desired State

- [x] Verify every uncommented entry in `Brewfile` has a corresponding declaration in `flake.nix`:
  - `ctags` → `pkgs.universal-ctags` (universal-ctags supersedes exuberant ctags)
  - `git-lfs` → `pkgs.git-lfs`
  - `caarlos0/tap/timer` → `brews = ["caarlos0/tap/timer"]`
  - `terminal-notifier` → `pkgs.terminal-notifier`
  - `yazi`, `ffmpegthumbnailer`, `unar`, `jq`, `poppler`, `fd`, `fzf` → all in `environment.systemPackages`
  - `font-symbols-only-nerd-font` → `fonts.packages` NerdFontsSymbolsOnly
  - All casks (`zen-browser`, `discord`, `fantastical`, `figma`, `kitty`, `notion`, `obsidian`, `rectangle`, `vitals`) → `homebrew.casks`
  - `mas 'reMarkable'` → `homebrew.masApps`
- [x] Delete `Brewfile`

## Phase 2: Update Makefile

> Reference: packages.md §Desired State — Brewfile is deleted, so its consumers must be updated

The `install_brew` and `install_packages` targets exist solely to run `brew bundle` from the Brewfile. With the Brewfile gone, they are dead code.

- [x] Remove the `install_brew` target
- [x] Remove the `install_packages` target
- [x] Update the `all` target from `all: install_packages apply_dotfiles configure_macos` to `all: apply_dotfiles configure_macos`
- [x] Update the `.PHONY` line to remove `install_packages` and `install_brew`

After this change the Makefile retains `apply_dotfiles`, `configure_macos`, and `restore_backup` — all still useful until bootstrap.md and macos.md plans absorb them.

## Phase 3: Update specs

- [x] Update `specs/packages.md`:
  - Current State: note that Brewfile has been deleted and flake.nix is the single source of truth
  - Desired State: mark as achieved (no remaining delta)
- [x] Add this plan to the implementation plans table in `specs/README.md` (already added)

## Verification

```bash
# Brewfile is gone
test ! -f Brewfile && echo "Brewfile deleted"

# Makefile has no brew targets
! grep -q install_packages Makefile && echo "install_packages removed"
! grep -q install_brew Makefile && echo "install_brew removed"

# flake.nix still builds
darwin-rebuild build --flake ~/projects/dotfiles/nix#laptop

# All CLI tools resolve from Nix store
which nvim && which rg && which yazi && which tree && which zoxide

# Homebrew-managed apps still present (managed by nix-darwin homebrew block)
brew list --cask | grep -q kitty
brew list | grep -q timer

# Mac App Store
mas list | grep -q reMarkable
```
