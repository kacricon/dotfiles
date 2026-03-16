# macOS Implementation Plan

## Overview

Implement all macOS system preferences from `specs/macos.md` using nix-darwin `system.defaults` in `flake.nix`, replacing the legacy Makefile `configure_macos` approach.

## File Inventory

| File | Action | Purpose |
|------|--------|---------|
| `nix/flake.nix` | Modify | Add `system.defaults` block with all preferences |
| `Makefile` | Modify | Simplify `configure_macos` target (nix-darwin handles it now) |
| `specs/macos.md` | Modify | Update Current State, note nix-darwin approach |
| `specs/README.md` | Modify | Add this plan to the implementation plans table |

## Phase 1: Add system.defaults to flake.nix

Add a `system.defaults` block to the `configuration` module in `nix/flake.nix` with the following settings:

### Dock (macos.md §Desired State)

- [x] `system.defaults.dock.autohide = true` — auto-hide dock
- [x] `system.defaults.dock.minimize-to-application = true` — minimize to app icon
- [x] `system.defaults.CustomUserPreferences."com.apple.dock".appswitcher-all-displays = true` — app switcher on all displays (via CustomUserPreferences since not a first-class nix-darwin option)

### Finder (macos.md §Desired State)

- [x] `system.defaults.finder.AppleShowAllExtensions = true` — show file extensions
- [x] `system.defaults.finder.AppleShowAllFiles = true` — show hidden files
- [x] `system.defaults.finder.FXPreferredViewStyle = "Nlsv"` — default to list view
- [x] `system.defaults.finder.ShowPathbar = true` — show path bar

### Keyboard (macos.md §Desired State)

- [x] `system.defaults.NSGlobalDomain.KeyRepeat = 2` — fast key repeat
- [x] `system.defaults.NSGlobalDomain.InitialKeyRepeat = 15` — short initial repeat delay
- [x] `system.keyboard.enableKeyMapping = true` + `system.keyboard.remapCapsLockToEscape = true` — Caps Lock → Escape

### Screenshots (macos.md §Desired State)

- [x] `system.defaults.screencapture.location = "~/Screenshots"` — save to ~/Screenshots
- [x] `system.defaults.screencapture.disable-shadow = true` — no drop shadow
- [x] Activation script to create `~/Screenshots` directory

### Trackpad (macos.md §Desired State)

- [x] `system.defaults.trackpad.Clicking = true` — tap to click
- [x] `system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = true` — natural scrolling

### Infrastructure

- [x] `system.primaryUser = "jrc"` — required by nix-darwin for user-scoped defaults

### Fixes discovered during implementation

- [x] `pkgs.poppler_utils` → `pkgs.poppler-utils` (renamed in nixpkgs)
- [x] `pkgs.nerdfonts.override { ... }` → `pkgs.nerd-fonts.symbols-only` (renamed in nixpkgs)

## Phase 2: Rectangle preferences

- [x] Export current Rectangle config: `defaults export com.knollsoft.Rectangle -`
- [x] Store relevant preferences via `system.defaults.CustomUserPreferences."com.knollsoft.Rectangle"`
- [x] Keys stored: `launchOnLogin`, `alternateDefaultShortcuts`, `gapSize`, `subsequentExecutionMode`, `snapEdgeMargin{Top,Bottom,Left,Right}`

## Phase 3: Update Makefile

- [x] Replace the `configure_macos` body with a message pointing to `nix/flake.nix` system.defaults
- [x] Keep `apply_dotfiles` and `restore_backup` targets (still useful outside nix-darwin)

## Phase 4: Update specs

- [x] Update `specs/macos.md` Current State to reflect nix-darwin implementation
- [x] Update `specs/macos.md` Implementation Files to reference `nix/flake.nix` as primary
- [x] Add this plan to `specs/README.md` implementation plans table (already present)

## Verification

```bash
# Rebuild system
sudo darwin-rebuild switch --flake ~/projects/dotfiles/nix#laptop

# Spot-check settings
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

# Ensure ~/Screenshots directory exists
ls -d ~/Screenshots
```
