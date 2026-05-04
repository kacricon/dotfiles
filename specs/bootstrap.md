# Bootstrap

## Overview

The bootstrap spec defines how a fresh Mac goes from zero to a fully configured development environment. The goal is a single `curl | sh` command that is idempotent — re-running it applies the latest configuration without errors.

## Current State

`setup.sh` is the single bootstrap entry point. Each step is idempotent:

1. Install Xcode Command Line Tools (skips if present)
2. Install Nix via Determinate Systems installer (skips if present)
3. Clone repo to `~/projects/dotfiles` (pulls if exists, clones if not)
4. Run `darwin-rebuild switch --flake ~/projects/dotfiles/nix#laptop`
5. Apply dotfiles via `make apply_dotfiles` (backup + copy — includes `.zshrc`, `.config`)
6. Print post-bootstrap manual checklist (git identity, Bitwarden extension, default browser, himalaya keychain entry)

Also available: `make all` (steps 4+5), `make bootstrap` (runs `setup.sh`).

**Files:** `setup.sh`, `Makefile`, `nix/flake.nix`

## Desired State

No remaining delta. All bootstrap steps are implemented.

Bootstrap command:

```bash
curl -fsSL https://raw.githubusercontent.com/jrc/dotfiles/master/setup.sh | sh
```

## Design Decisions

- **Nix over Makefile**: nix-darwin rebuild replaces `make install_packages`. The Makefile remains for `apply_dotfiles` and `configure_macos` until those are absorbed into nix-darwin or home-manager.
- **No interactive prompts**: setup.sh must run unattended after the initial `curl`.
- **Backup safety**: always create `~/dotfiles_backup` before overwriting dotfiles.
- **Hostname-generic**: the flake uses `laptop` as the configuration name, not a specific hostname.
- **Himalaya keychain**: the himalaya config uses `security find-internet-password` to fetch the mailbox.org password at runtime. On a fresh Mac, register it once with:
  ```bash
  security add-internet-password -s "imap.mailbox.org" -a "julioribeiro@mailbox.org" -w
  ```

## Dependencies

- [packages](packages.md) — nix-darwin must be configured before rebuild
- [macos](macos.md) — system preferences applied after packages

## Implementation Files

- `setup.sh`
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
