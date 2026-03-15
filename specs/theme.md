# Theme

## Overview

Catppuccin Frappe is the universal theme across all tools. Every application that supports theming should use Frappe for visual consistency.

## Current State

| Tool | Themed? | How |
|------|---------|-----|
| Kitty | Yes | `current-theme.conf` (full Frappe palette) |
| Neovim | Yes | catppuccin/nvim plugin, `flavour = "frappe"` |
| Yazi | No | Uses default colors |

**Files:** `.config/kitty/current-theme.conf`, `.config/nvim/init.lua`

## Desired State

| Tool | Themed? | How |
|------|---------|-----|
| Kitty | Yes | `current-theme.conf` (no change) |
| Neovim | Yes | catppuccin/nvim (no change) |
| Yazi | Yes | `.config/yazi/theme.toml` from catppuccin/yazi |

## Design Decisions

- **Frappe, not Mocha/Latte/Macchiato**: Frappe has the right contrast for daily use.
- **Per-tool theme files**: each tool manages its own theme config rather than generating from a single source. This avoids build complexity.
- **Official ports**: use catppuccin's official theme ports where available.

## Dependencies

- [editor](editor.md) — Neovim catppuccin plugin
- [terminal](terminal.md) — Kitty theme file
- [file-manager](file-manager.md) — Yazi theme file

## Implementation Files

- `.config/kitty/current-theme.conf`
- `.config/nvim/init.lua` (catppuccin setup block)
- `.config/yazi/theme.toml` (to be created)

## Verification

```bash
# Visual check: open kitty, neovim, and yazi side-by-side
# Background should be #303446 (Frappe base) in all three
# Accent colors should be consistent (lavender, mauve, peach, etc.)
```
