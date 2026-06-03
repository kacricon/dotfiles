# Packages

## Overview

All packages are managed declaratively. Nix-darwin owns the full package set; setup.sh installs Homebrew itself, and Homebrew is used only where Nix has no equivalent (GUI casks, Mac App Store apps via `mas`, and taps not in nixpkgs).

## Current State

`nix/flake.nix` is the single source of truth for all packages. The legacy `Brewfile` has been deleted.

**Nix-darwin** (`nix/flake.nix`) manages:
- CLI tools: universal-ctags, neovim, tree-sitter, ripgrep, git, git-lfs, tree, tlrc, exercism, terminal-notifier, codex, zoxide, bun, nodejs, python3
- Yazi + deps: yazi, ffmpegthumbnailer, unar, jq, poppler_utils, fd, fzf
- External flakes: hermes-agent (from `github:NousResearch/hermes-agent`)
- Fonts: NerdFontsSymbolsOnly
- Homebrew integration (casks, brews, masApps) with `cleanup = "zap"`

**Homebrew** (via nix-darwin `homebrew` block):
- Taps: `caarlos0/tap`
- Brews: `caarlos0/tap/timer`, `rtk` (not in nixpkgs)
- Casks: claude-code, codex-app, discord, fantastical, figma, google-chrome, helium-browser, kitty, notion, obsidian, qobuz, rectangle, roon, spotify, stremio, vitals
Adding a package means editing `flake.nix` and running `make rebuild`.
Refreshing package versions means updating the nixpkgs lock with `make update_nixpkgs`
or running `make upgrade` to update nixpkgs and rebuild in one step.

**Files:** `nix/flake.nix`

## Desired State

No remaining delta — current state matches desired state.

### Package inventory

**Nix system packages** (CLI):
universal-ctags, neovim, tree-sitter, ripgrep, git, git-lfs, tree, tlrc, exercism, terminal-notifier, codex, zoxide, yazi, ffmpegthumbnailer, unar, jq, poppler_utils, fd, fzf, bun, nodejs, python3

**External flake packages:**
hermes-agent (via `github:NousResearch/hermes-agent`)

**Homebrew brews** (no Nix equivalent):
caarlos0/tap/timer, rtk

**Homebrew casks** (GUI apps):
claude-code, codex-app, discord, fantastical, figma, google-chrome, helium-browser, kitty, notion, obsidian, qobuz, rectangle, roon, spotify, stremio, vitals

**Fonts:**
NerdFontsSymbolsOnly (via nixpkgs)

## Design Decisions

- **Nix-first**: every CLI tool goes into `environment.systemPackages` unless it genuinely doesn't exist in nixpkgs.
- **Homebrew cleanup = "zap"**: nix-darwin removes casks/brews not declared in the flake, keeping the system clean.
- **Codex split**: `pkgs.codex` provides the terminal CLI; the desktop app is managed as the `codex-app` Homebrew cask.
- **Pinned nixpkgs input**: `flake.lock` pins `nixpkgs-unstable` for reproducible rebuilds. Run `make update_nixpkgs` when package freshness is desired.
- **timer stays in Homebrew**: `caarlos0/tap/timer` is a custom tap with no nixpkgs equivalent.

## Dependencies

- [bootstrap](bootstrap.md) — nix-darwin must be installed first

## Implementation Files

- `nix/flake.nix`

## Verification

```bash
make rebuild

# Refresh nixpkgs before rebuilding:
make upgrade

# CLI tools from Nix:
which nvim && which tree-sitter && which rg && which yazi && which tree && which bun && which codex

# Homebrew-managed apps:
brew list --cask | grep -q kitty
brew list --cask | grep -q codex-app
brew list | grep -q timer
```
