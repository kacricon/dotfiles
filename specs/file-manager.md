# File Manager

## Overview

Yazi is the terminal file manager, configured minimally with hidden files visible and Neovim as the editor.

## Current State

`.config/yazi/yazi.toml`:
- `show_hidden = true`
- Panel ratio: `[2, 4, 3]`
- Preview max: 1200x1800
- Opener: `nvim "$@"`

`.config/yazi/theme.toml`:
- Catppuccin Frappe theme (lavender accent) from catppuccin/yazi

`.config/yazi/Catppuccin-frappe.tmTheme`:
- Syntax highlighting theme for file preview pane from catppuccin/bat

**Files:** `.config/yazi/yazi.toml`, `.config/yazi/theme.toml`, `.config/yazi/Catppuccin-frappe.tmTheme`

## Desired State

Everything is implemented. No outstanding changes.

## Design Decisions

- **Minimal config**: only override what differs from defaults.
- **nvim as opener**: consistent with the rest of the setup.
- **Show hidden files**: needed for dotfile work.

## Dependencies

- [packages](packages.md) — yazi and its deps (ffmpegthumbnailer, unar, jq, poppler, fd, fzf)
- [theme](theme.md) — Catppuccin Frappe theme.toml

## Implementation Files

- `.config/yazi/yazi.toml`
- `.config/yazi/theme.toml`
- `.config/yazi/Catppuccin-frappe.tmTheme`

## Verification

```bash
yazi --version
# Open yazi in a directory with hidden files:
yazi ~/projects/dotfiles
# Verify: .zshrc and .config are visible, colors match Catppuccin Frappe
```
