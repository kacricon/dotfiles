# Packages

## Overview

All packages are managed declaratively. Nix-darwin owns the full package set; setup.sh installs Homebrew itself, and Homebrew is used only where Nix has no equivalent (GUI casks, Mac App Store apps via `mas`, and taps not in nixpkgs).

## Current State

`nix/flake.nix` is the single source of truth for all packages. The legacy `Brewfile` has been deleted.
`nix/flake.nix` also adds `/opt/homebrew/bin` and `/opt/homebrew/sbin` to the nix-darwin system PATH so Homebrew-managed commands are available in new shells.

**Nix-darwin** (`nix/flake.nix`) manages:
- CLI tools: universal-ctags, neovim, tree-sitter, ripgrep, git, git-lfs, tree, tlrc, exercism, terminal-notifier, codex, zoxide, bun, nodejs, python3
- GUI apps available in nixpkgs: daisydisk
- Yazi + deps: yazi, ffmpegthumbnailer, unar, jq, poppler_utils, fd, fzf
- External flakes: hermes-agent (from `github:NousResearch/hermes-agent`)
- Fonts: NerdFontsSymbolsOnly
- Homebrew integration (casks, brews, masApps) with `cleanup = "zap"`

**Homebrew** (via nix-darwin `homebrew` block):
- Taps: `caarlos0/tap`
- Brews: `caarlos0/tap/timer`, `rtk` (not in nixpkgs)
- Casks: claude-code, codex-app, discord, fantastical, google-chrome, helium-browser, kitty, obsidian, qobuz, rectangle, spotify, stremio, vitals
Adding a package means editing `flake.nix` and running `make rebuild`.
Refreshing package versions means updating the nixpkgs lock with `make update_nixpkgs`
or running `make upgrade` to update nixpkgs and rebuild in one step.

**Files:** `nix/flake.nix`

## Desired State

No remaining delta — current state matches desired state.

### Package inventory

**Nix system packages**:
universal-ctags, neovim, tree-sitter, ripgrep, git, git-lfs, tree, tlrc, exercism, terminal-notifier, codex, zoxide, yazi, ffmpegthumbnailer, unar, jq, poppler_utils, fd, fzf, bun, nodejs, python3, daisydisk

**External flake packages:**
hermes-agent (via `github:NousResearch/hermes-agent`)

**Homebrew brews** (no Nix equivalent):
caarlos0/tap/timer, rtk

**Homebrew casks** (GUI apps):
claude-code, codex-app, discord, fantastical, google-chrome, helium-browser, kitty, obsidian, qobuz, rectangle, spotify, stremio, vitals

**Fonts:**
NerdFontsSymbolsOnly (via nixpkgs)

## Design Decisions

- **Nix-first**: every CLI tool goes into `environment.systemPackages` unless it genuinely doesn't exist in nixpkgs.
- **Narrow unfree allowlist**: unfree nixpkgs packages are allowed by package name only when explicitly declared; currently this allows `daisydisk`.
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
which brew | grep -q /opt/homebrew/bin/brew
brew list --cask | grep -q kitty
brew list --cask | grep -q codex-app
brew list | grep -q timer
```
