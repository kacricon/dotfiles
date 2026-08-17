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
- Taps: none
- Brews: `rtk` (not in nixpkgs)
- Casks: claude-code@latest, codex-app, discord, fantastical, google-chrome, helium-browser, iina, kitty, obsidian, qobuz, rectangle, spotify, stremio, vitals
Adding a package means editing `flake.nix` and running `make rebuild`.
Refreshing package versions means updating the compatible nixpkgs/nix-darwin lock pair with `make update_nix_inputs`
or running `make upgrade` to update both inputs and rebuild in one step. `make update_nixpkgs` remains as a backwards-compatible alias.
Updating Homebrew casks may require granting App Management permission to the terminal emulator that runs `make rebuild` or `setup.sh`.

**Files:** `nix/flake.nix`

`git-lfs` is installed as a package and initialized declaratively: the `system.activationScripts.extraActivation` block runs `git-lfs install --skip-repo` (as user `jrc`, with `HOME=/Users/jrc` and `pkgs.git` on PATH — the activation script's root `HOME` would otherwise write to `/var/root/.gitconfig`) on every rebuild, registering the LFS clean/smudge/filter entries in `~/.gitconfig`. This is idempotent.

## Desired State

No remaining delta — current state matches desired state.

### Package inventory

**Nix system packages**:
universal-ctags, neovim, tree-sitter, ripgrep, git, git-lfs, tree, tlrc, exercism, terminal-notifier, codex, zoxide, yazi, ffmpegthumbnailer, unar, jq, poppler_utils, fd, fzf, bun, nodejs, python3, daisydisk

**External flake packages:**
hermes-agent (via `github:NousResearch/hermes-agent`)

**Homebrew brews** (no Nix equivalent):
rtk

**Homebrew casks** (GUI apps):
claude-code@latest, codex-app, discord, fantastical, google-chrome, helium-browser, iina, kitty, obsidian, qobuz, rectangle, spotify, stremio, vitals

**Fonts:**
NerdFontsSymbolsOnly (via nixpkgs)

## Design Decisions

- **Nix-first**: every CLI tool goes into `environment.systemPackages` unless it genuinely doesn't exist in nixpkgs.
- **Narrow unfree allowlist**: unfree nixpkgs packages are allowed by package name only when explicitly declared; currently this allows `daisydisk`.
- **Homebrew cleanup = "zap"**: nix-darwin removes casks/brews not declared in the flake, keeping the system clean.
- **App Management permission**: Homebrew cask upgrades can update `.app` bundles in `/Applications`; macOS may block this until the invoking terminal emulator is allowed under System Settings > Privacy & Security > App Management.
- **Codex split**: `pkgs.codex` provides the terminal CLI; the desktop app is managed as the `codex-app` Homebrew cask.
- **Pinned Nix inputs**: `flake.lock` pins `nixpkgs-unstable` and nix-darwin for reproducible rebuilds. Run `make update_nix_inputs` when package freshness is desired; nix-darwin follows nixpkgs and should be updated with it to avoid build-tool mismatches.
- **Claude Code via `claude-code@latest` cask**: Claude Code releases very frequently. The plain `claude-code` cask is a slow-moving versioned pin that lags releases, and `nixpkgs#claude-code` trails further behind (unstable PR + Hydra cycle, only bumped when the flake inputs are updated). The `@latest` cask tracks the newest release, so it is preferred over both the versioned cask and a Nix package here.

## Dependencies

- [bootstrap](bootstrap.md) — nix-darwin must be installed first

## Implementation Files

- `nix/flake.nix`

## Verification

```bash
make rebuild

# If macOS blocks Homebrew cask updates:
# System Settings > Privacy & Security > App Management
# Allow the terminal emulator used to run make, then rerun make rebuild

# Refresh nixpkgs/nix-darwin before rebuilding:
make upgrade

# CLI tools from Nix:
which nvim && which tree-sitter && which rg && which yazi && which tree && which bun && which codex

# Homebrew-managed apps:
which brew | grep -q /opt/homebrew/bin/brew
brew list --cask | grep -q kitty
brew list --cask | grep -q codex-app
```
