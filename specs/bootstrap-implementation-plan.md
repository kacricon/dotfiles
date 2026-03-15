# Bootstrap Implementation Plan

## Overview

Create `setup.sh` — an idempotent bootstrap script that takes a fresh Mac from zero to a fully configured development environment. Implements the desired state from [bootstrap.md](bootstrap.md).

## File Inventory

| File | Action | Description |
|------|--------|-------------|
| `setup.sh` | Create | Main bootstrap script |
| `Makefile` | Modify | Add `bootstrap` target that runs `setup.sh` |
| `specs/bootstrap.md` | Update | Move items to "Current State" |
| `specs/README.md` | Update | Add this implementation plan |

## Phase 1: Create `setup.sh`

- [x] Create `setup.sh` with these idempotent steps:
  1. Install Xcode Command Line Tools (skip if `xcode-select -p` succeeds)
  2. Install Nix via Determinate Systems installer (skip if `nix --version` succeeds)
  3. Clone repo to `~/projects/dotfiles` (skip if exists, `git pull` if exists)
  4. Run `darwin-rebuild switch --flake ~/projects/dotfiles/nix#laptop`
  5. Apply dotfiles via `make apply_dotfiles`
- [x] Make script `chmod +x`
- [x] No interactive prompts — fully unattended after initial `curl`

## Phase 2: Wire into Makefile

- [x] Add `bootstrap` target to Makefile that runs `setup.sh`

## Phase 3: Verify

- [x] Run `setup.sh` on current machine — all steps should skip or succeed
- [x] Verify idempotency: run twice, second run should be a no-op

## Phase 4: Update specs

- [x] Update `specs/bootstrap.md` current state
- [x] Update `specs/README.md` with this plan
- [x] Update `CLAUDE.md` architecture if needed

## Verification

```bash
# On existing machine (idempotent test):
bash setup.sh
# All steps should complete or skip with messages

# Check results:
which nvim        # nix store path
which yazi        # nix store path
diff ~/.zshrc ~/projects/dotfiles/.zshrc  # no diff
```
