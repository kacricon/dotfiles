# Bootstrap

## Overview

The bootstrap spec defines how a fresh Mac goes from zero to a fully configured development environment. The goal is a single `curl | sh` command that is idempotent — re-running it applies the latest configuration without errors.

## Current State

Setup uses nix-darwin + Makefile:

1. Clone the repo manually to `~/projects/dotfiles`
2. Run `make all`, which calls: `rebuild` (nix-darwin switch), `apply_dotfiles` (copy to `$HOME`)
3. Packages and macOS preferences are managed by nix-darwin (`nix/flake.nix`)

**Files:** `Makefile`, `nix/flake.nix`

## Desired State

A single command bootstraps everything:

```bash
curl -fsSL https://raw.githubusercontent.com/jrc/dotfiles/master/setup.sh | sh
```

`setup.sh` handles these steps (each idempotent):

1. Install Xcode Command Line Tools (skip if present)
2. Install Nix via Determinate Systems installer (skip if present)
3. Clone repo to `~/projects/dotfiles` (skip if exists, `git pull` if exists)
4. Run `darwin-rebuild switch --flake ~/projects/dotfiles/nix#laptop`
5. Apply dotfiles: copy `.zshrc` and `.config/` to `$HOME` (with backup)

Re-running the script at any point should converge to the desired state.

## Design Decisions

- **Nix over Makefile**: nix-darwin rebuild replaces `make install_packages`. The Makefile remains for `apply_dotfiles` and `configure_macos` until those are absorbed into nix-darwin or home-manager.
- **No interactive prompts**: setup.sh must run unattended after the initial `curl`.
- **Backup safety**: always create `~/dotfiles_backup` before overwriting dotfiles.
- **Hostname-generic**: the flake uses `laptop` as the configuration name, not a specific hostname.

## Dependencies

- [packages](packages.md) — nix-darwin must be configured before rebuild
- [macos](macos.md) — system preferences applied after packages

## Implementation Files

- `setup.sh` (to be created)
- `Makefile`
- `nix/flake.nix`

## Verification

```bash
# On a fresh Mac (or after wiping nix):
curl -fsSL <raw-url>/setup.sh | sh

# Verify:
which nvim        # → /nix/store/...
which yazi        # → /nix/store/...
kitty --version   # GUI app installed
diff ~/.zshrc ~/projects/dotfiles/.zshrc  # no diff
```
