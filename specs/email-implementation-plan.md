# Email Implementation Plan

Implementation checklist for adding himalaya to the package set.

> Spec: [packages.md](packages.md)
> Created: 2026-04-22

## Overview

Add `pkgs.himalaya` to `environment.systemPackages` in `nix/flake.nix` so the himalaya email CLI is
available system-wide. Himalaya is in nixpkgs (v1.1.0 for aarch64-darwin), so no external flake or
Homebrew tap is needed.

This is a stepping stone toward an inbox-control agent that uses himalaya to read, triage, and
manage email from the terminal.

## File Inventory

| File | Action | Purpose |
|------|--------|---------|
| `nix/flake.nix` | Modify | Add `pkgs.himalaya` to `environment.systemPackages` |
| `specs/packages.md` | Modify | Update Current State and Desired State (done) |
| `specs/README.md` | Modify | Register this plan in the implementation plans table |

## Phase 1: Add himalaya to flake.nix

> Reference: packages.md §Desired State

- [x] Add `pkgs.himalaya` to `environment.systemPackages` in `nix/flake.nix`, under the
      "terminal tools" comment block, after `python3`.

```nix
# terminal tools
pkgs.universal-ctags
pkgs.neovim
...
pkgs.python3
pkgs.himalaya    # ← add this line
```

## Phase 2: Rebuild and verify

- [x] Run `darwin-rebuild switch --flake ~/projects/dotfiles/nix#laptop`
- [x] Verify: `which himalaya` resolves to a path in the Nix store
- [x] Verify: `himalaya --version` prints `1.1.0` (or newer)

## Phase 3: Update specs

- [x] Update `specs/packages.md`: move himalaya from Desired State to Current State, restore
      "No remaining delta" note in Desired State.
- [x] Add this plan to the implementation plans table in `specs/README.md`.

## Verification

```bash
# After darwin-rebuild switch:
which himalaya          # should point to /run/current-system/sw/bin/himalaya or Nix store
himalaya --version      # should print version string
```
