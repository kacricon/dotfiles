# Bootstrap

## Overview

The bootstrap spec defines how a fresh Mac goes from zero to a fully configured development environment. The goal is a single `curl | sh` command that is idempotent — re-running it applies the latest configuration without errors.

## Current State

`setup.sh` is the single bootstrap entry point. Each step is idempotent:

1. Install Xcode Command Line Tools (skips if present)
2. Install Nix via Determinate Systems installer (skips if present)
3. Install Homebrew (skips if present)
4. Clone repo to `~/projects/dotfiles` from the public HTTPS URL (fetches and fast-forwards if exists, clones if not; git terminal prompts are disabled)
5. Run `sudo -H darwin-rebuild switch --flake ~/projects/dotfiles/nix#laptop`, falling back to `sudo -H nix run ~/projects/dotfiles/nix#darwin-rebuild` for the first switch before `darwin-rebuild` is installed
6. Apply dotfiles via `make apply_dotfiles` (backup + sync — includes `.zshrc`, `.config/nvim`, `.config/kitty`, `.config/yazi`)
7. Print post-bootstrap manual checklist (git identity, Bitwarden extension, default browser)

Also available: `make all` (steps 5+6), `make bootstrap` (runs `setup.sh`).

**Files:** `setup.sh`, `Makefile`, `nix/flake.nix`

## Desired State

No remaining delta. All bootstrap steps are implemented.

Bootstrap command:

```bash
curl -fsSL https://raw.githubusercontent.com/kacricon/dotfiles/master/setup.sh | sh
```

## Design Decisions

- **Nix over Makefile**: nix-darwin rebuild replaces `make install_packages`. The Makefile remains for `apply_dotfiles` and `configure_macos` until those are absorbed into nix-darwin or home-manager.
- **Homebrew bootstrap**: setup.sh installs Homebrew with the official installer before nix-darwin activation. The installer runs as the normal user after sudo is validated through `/dev/tty`, because Homebrew rejects root execution but needs sudo access for privileged setup work. nix-darwin manages Homebrew taps, brews, casks, and cleanup after Homebrew itself exists.
- **No avoidable prompts**: setup.sh avoids package/auth prompts where possible. macOS may still show the Xcode Command Line Tools dialog, and sudo authentication is required for nix-darwin system activation.
- **Public read-only repo access**: bootstrap uses `https://github.com/kacricon/dotfiles.git` with `GIT_TERMINAL_PROMPT=0`, so a stale or unavailable GitHub URL fails immediately instead of requesting username/password auth.
- **Determinate owns Nix**: Nix is installed and managed by Determinate Nix. nix-darwin sets `nix.enable = false` so it does not take over the Nix installation, daemon, or `/etc/nix/nix.conf`.
- **First nix-darwin switch**: setup.sh and `make rebuild` use the flake-exposed `darwin-rebuild` package as root when the command is not installed yet. Subsequent runs use the installed `darwin-rebuild`, also as root. Both paths use `sudo -H` so Nix does not inherit the invoking user's `$HOME`.
- **Dirty checkout safety**: reruns skip automatic repo updates when `~/projects/dotfiles` has local changes, avoiding accidental clobbering.
- **Dotfile ownership**: `make apply_dotfiles` syncs only `.zshrc` and managed config directories (`nvim`, `kitty`, `yazi`) so repeat runs do not overwrite unrelated `~/.config` state.
- **Backup safety**: create missing backups in `~/dotfiles_backup` before overwriting managed dotfiles, but leave existing backups unchanged on reruns.
- **Hostname-generic**: the flake uses `laptop` as the configuration name, not a specific hostname.

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
