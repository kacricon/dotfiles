# Packages

## Overview

All packages are managed declaratively. Nix-darwin owns the full package set; Homebrew is used only where Nix has no equivalent (GUI casks, Mac App Store apps via `mas`, and taps not in nixpkgs).

## Current State

Two package managers coexist:

**Nix-darwin** (`nix/flake.nix`) manages:
- CLI tools: universal-ctags, neovim, ripgrep, git, git-lfs, tree, tlrc, exercism, terminal-notifier, zoxide
- Yazi + deps: yazi, ffmpegthumbnailer, unar, jq, poppler_utils, fd, fzf
- Fonts: NerdFontsSymbolsOnly
- Homebrew integration (casks, brews, masApps) with `cleanup = "zap"`

**Homebrew** (via nix-darwin `homebrew` block):
- Taps: `caarlos0/tap`
- Brews: `caarlos0/tap/timer` (not in nixpkgs)
- Casks: arc, discord, fantastical, figma, kitty, notion, obsidian, rectangle, vitals
- Mac App Store: reMarkable

**Legacy Brewfile** still exists with overlapping definitions. Several CLI tools are commented out (managed by Nix now).

**Files:** `nix/flake.nix`, `Brewfile`

## Desired State

- `nix/flake.nix` is the single source of truth for all packages.
- The `homebrew` block inside flake.nix handles casks, `mas` apps, and the `timer` tap.
- `Brewfile` is deleted. All its content is already represented in flake.nix.
- Adding a package means editing flake.nix and running `darwin-rebuild switch`.

### Package inventory

**Nix system packages** (CLI):
universal-ctags, neovim, ripgrep, git, git-lfs, tree, tlrc, exercism, terminal-notifier, zoxide, yazi, ffmpegthumbnailer, unar, jq, poppler_utils, fd, fzf

**Homebrew brews** (no Nix equivalent):
caarlos0/tap/timer

**Homebrew casks** (GUI apps):
arc, discord, fantastical, figma, kitty, notion, obsidian, rectangle, vitals

**Mac App Store:**
reMarkable (id: 1276493162)

**Fonts:**
NerdFontsSymbolsOnly (via nixpkgs)

## Design Decisions

- **Nix-first**: every CLI tool goes into `environment.systemPackages` unless it genuinely doesn't exist in nixpkgs.
- **Homebrew cleanup = "zap"**: nix-darwin removes casks/brews not declared in the flake, keeping the system clean.
- **No pinning yet**: using `nixpkgs-unstable` for latest packages. Pin to a specific commit if reproducibility becomes critical.
- **timer stays in Homebrew**: `caarlos0/tap/timer` is a custom tap with no nixpkgs equivalent.

## Dependencies

- [bootstrap](bootstrap.md) — nix-darwin must be installed first

## Implementation Files

- `nix/flake.nix`
- `Brewfile` (to be deleted)

## Verification

```bash
darwin-rebuild switch --flake ~/projects/dotfiles/nix#laptop

# CLI tools from Nix:
which nvim && which rg && which yazi && which tree

# Homebrew-managed apps:
brew list --cask | grep -q kitty
brew list | grep -q timer

# Mac App Store:
mas list | grep -q reMarkable
```
