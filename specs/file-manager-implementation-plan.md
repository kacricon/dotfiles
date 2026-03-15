# File Manager Implementation Plan

## Overview

Add Catppuccin Frappe theme to Yazi. This is the only gap in the file-manager spec and also closes the theme spec's last remaining item (Yazi is the only unthemed tool).

## File Inventory

| File | Action | Purpose |
|------|--------|---------|
| `.config/yazi/theme.toml` | Create | Catppuccin Frappe theme (lavender accent) from [catppuccin/yazi](https://github.com/catppuccin/yazi) |
| `.config/yazi/Catppuccin-frappe.tmTheme` | Create | Syntax highlighting theme for Yazi's file preview pane, from [catppuccin/bat](https://github.com/catppuccin/bat) |
| `specs/file-manager.md` | Modify | Move theme from Desired to Current State |
| `specs/theme.md` | Modify | Mark Yazi as themed |

No changes needed to `Makefile` — `apply_dotfiles` already copies all of `.config/` to `$HOME`.

## Phases

### Phase 1 — Add theme files

- [x] Create `.config/yazi/theme.toml` with the `catppuccin-frappe-lavender` theme from the official catppuccin/yazi repo (file-manager.md §Desired State, theme.md §Desired State)
- [x] Download `Catppuccin-frappe.tmTheme` from catppuccin/bat and place it at `.config/yazi/Catppuccin-frappe.tmTheme` — this is referenced by `theme.toml`'s `syntect_theme` key for syntax-highlighted file previews

### Phase 2 — Update specs

- [x] Update `specs/file-manager.md`: move "Add Catppuccin Frappe theme" from Desired State to Current State, add `theme.toml` and tmTheme to file list
- [x] Update `specs/theme.md`: change Yazi row from "No" to "Yes" in both Current and Desired State tables

## Verification

```bash
# Theme file exists and is valid TOML
cat .config/yazi/theme.toml | head -5
# Should show [app] section with #303446 (Frappe base)

# tmTheme file exists
test -f .config/yazi/Catppuccin-frappe.tmTheme && echo "ok"

# Apply dotfiles and verify they land in $HOME
make apply_dotfiles
diff .config/yazi/theme.toml ~/.config/yazi/theme.toml  # no diff

# Visual: open yazi, background should be #303446
yazi ~/projects/dotfiles
```
