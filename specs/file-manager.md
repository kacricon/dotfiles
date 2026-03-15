# File Manager

## Overview

Yazi is the terminal file manager, configured minimally with hidden files visible and Neovim as the editor.

## Current State

`.config/yazi/yazi.toml`:
- `show_hidden = true`
- Panel ratio: `[2, 4, 3]`
- Preview max: 1200x1800
- Opener: `nvim "$@"`
- **No theme file** — uses Yazi's default colors

**Files:** `.config/yazi/yazi.toml`

## Desired State

- Add Catppuccin Frappe theme: create `.config/yazi/theme.toml` from the official catppuccin/yazi port
- Everything else stays as-is

## Design Decisions

- **Minimal config**: only override what differs from defaults.
- **nvim as opener**: consistent with the rest of the setup.
- **Show hidden files**: needed for dotfile work.

## Dependencies

- [packages](packages.md) — yazi and its deps (ffmpegthumbnailer, unar, jq, poppler, fd, fzf)
- [theme](theme.md) — Catppuccin Frappe theme.toml

## Implementation Files

- `.config/yazi/yazi.toml`
- `.config/yazi/theme.toml` (to be created)

## Verification

```bash
yazi --version
# Open yazi in a directory with hidden files:
yazi ~/projects/dotfiles
# Verify: .zshrc and .config are visible, colors match Catppuccin Frappe
```
