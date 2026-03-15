# Terminal

## Overview

Kitty is the terminal emulator, chosen for GPU rendering, remote control support (required by vim-slime), and native image display.

## Current State

`.config/kitty/kitty.conf`:
- **Font**: IBM Plex Mono, size 16, with Symbols Nerd Font Mono for icon glyphs (`U+E000-U+F8FF`)
- **Window**: decorations hidden, 10px padding
- **Theme**: Catppuccin Frappe via `include current-theme.conf`
- **Remote control**: enabled (`allow_remote_control yes`, `listen_on unix:/tmp/kitty`)

`.config/kitty/current-theme.conf`:
- Full Catppuccin Frappe color definitions (foreground, background, cursor, 16 ANSI colors, tab bar, marks)

**Files:** `.config/kitty/kitty.conf`, `.config/kitty/current-theme.conf`

## Desired State

Current state is correct. No changes needed.

## Design Decisions

- **Remote control**: required for vim-slime REPL workflow. The unix socket at `/tmp/kitty` is the communication channel.
- **Nerd Font as symbol map**: keeps IBM Plex Mono as the primary font while getting icons for tools like yazi and neo-tree.
- **Hide decorations**: maximizes usable screen space.

## Dependencies

- [packages](packages.md) — kitty installed as Homebrew cask (via nix-darwin), NerdFontsSymbolsOnly via Nix
- [theme](theme.md) — Catppuccin Frappe theme file

## Implementation Files

- `.config/kitty/kitty.conf`
- `.config/kitty/current-theme.conf`

## Verification

```bash
kitty --version
# Inside kitty:
echo -e "\ue0b0 \uf113 \uf7bd"   # Nerd Font glyphs render correctly
kitty @ ls                         # Remote control responds
```
