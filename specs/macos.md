# macOS

## Overview

macOS system preferences are applied programmatically via `defaults write` commands to ensure reproducibility across machines.

## Current State

The `Makefile` `configure_macos` target runs one command:
- `defaults write com.apple.dock appswitcher-all-displays -bool true` (app switcher on all displays)
- `killall Dock` to apply

No Rectangle preferences are managed programmatically (no `rectangle-preferences.json` found in repo).

**Files:** `Makefile` (configure_macos target)

## Desired State

Expand `defaults write` coverage to include:

- **Dock**: app switcher on all displays (existing), auto-hide, minimize to application
- **Finder**: show extensions, show hidden files, default to list view, show path bar
- **Keyboard**: fast key repeat, short initial repeat delay
- **Screenshots**: save to `~/Screenshots`, disable shadow
- **Trackpad**: tap to click, natural scrolling
- **Rectangle**: apply preferences programmatically (export current config, store in repo)

All preferences should be applied idempotently. Eventually move these into nix-darwin `system.defaults` once the full migration is complete.

## Design Decisions

- **`defaults write` for now**: simple, no dependencies beyond macOS. Migrate to nix-darwin `system.defaults` later.
- **Idempotent**: every command can be re-run safely.
- **killall only when needed**: batch all `defaults write` commands, restart affected processes once at the end.

## Dependencies

- [bootstrap](bootstrap.md) — preferences applied as part of setup
- [packages](packages.md) — Rectangle must be installed

## Implementation Files

- `Makefile` (configure_macos target)
- `nix/flake.nix` (future: `system.defaults` block)

## Verification

```bash
make configure_macos

# Spot-check:
defaults read com.apple.dock appswitcher-all-displays  # → 1
defaults read com.apple.finder AppleShowAllExtensions   # → 1 (after implementation)
```
