# macOS

## Overview

macOS system preferences are applied declaratively via nix-darwin `system.defaults` in `nix/flake.nix`.

## Current State

All preferences are managed via `system.defaults` in `nix/flake.nix`:

- **Dock**: app switcher on all displays, auto-hide, minimize to application
- **Finder**: show extensions, show hidden files, default to list view, show path bar
- **Keyboard**: fast key repeat (`KeyRepeat = 2`), short initial repeat delay (`InitialKeyRepeat = 15`), Caps Lock remapped to Escape (`system.keyboard.remapCapsLockToEscape`)
- **Screenshots**: save to `~/Screenshots`, disable shadow
- **Trackpad**: tap to click, natural scrolling
- **Rectangle**: launch on login, alternate shortcuts, 5px gap/snap margins, cycle sizes on repeat

**Files:** `nix/flake.nix` (system.defaults block)

## Desired State

No remaining delta. All macOS preferences are implemented.

## Design Decisions

- **nix-darwin `system.defaults`**: declarative, reproducible, applied on `darwin-rebuild switch`.
- **`system.primaryUser`**: required by nix-darwin for user-scoped defaults (set to `jrc`).
- **`CustomUserPreferences`**: used for dock options not exposed as first-class nix-darwin options (e.g., `appswitcher-all-displays`).
- **Activation script**: creates `~/Screenshots` directory on rebuild.

## Dependencies

- [bootstrap](bootstrap.md) — preferences applied as part of setup
- [packages](packages.md) — Rectangle must be installed

## Implementation Files

- `nix/flake.nix` (system.defaults block, system.primaryUser, activation script)

## Verification

```bash
sudo darwin-rebuild switch --flake ~/projects/dotfiles/nix#laptop

# Spot-check:
defaults read com.apple.dock autohide                         # → 1
defaults read com.apple.dock appswitcher-all-displays         # → 1
defaults read com.apple.dock minimize-to-application          # → 1
defaults read com.apple.finder AppleShowAllExtensions         # → 1
defaults read com.apple.finder AppleShowAllFiles              # → 1
defaults read com.apple.finder FXPreferredViewStyle           # → Nlsv
defaults read com.apple.finder ShowPathbar                    # → 1
defaults read NSGlobalDomain KeyRepeat                        # → 2
defaults read NSGlobalDomain InitialKeyRepeat                 # → 15
defaults read com.apple.screencapture location                # → ~/Screenshots
defaults read com.apple.screencapture disable-shadow          # → 1
defaults read com.apple.AppleMultitouchTrackpad Clicking      # → 1
defaults read NSGlobalDomain com.apple.swipescrolldirection   # → 1
ls -d ~/Screenshots                                          # → exists
hidutil property --get UserKeyMapping                         # → Caps Lock (0x700000039) → Escape (0x700000029)
```
