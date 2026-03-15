# Specs

Each spec describes the **desired end-state** for one concern. Specs are the source of intent; code is the source of truth. Always read the code before assuming a spec is implemented.

| Spec | Description | Key Files |
|------|-------------|-----------|
| [bootstrap](bootstrap.md) | Fresh Mac setup pipeline | `setup.sh`, `Makefile` |
| [packages](packages.md) | Package management (Nix-darwin + Homebrew fallback) | `nix/flake.nix`, `Brewfile` |
| [shell](shell.md) | Zsh configuration | `.zshrc` |
| [editor](editor.md) | Neovim configuration | `.config/nvim/init.lua` |
| [terminal](terminal.md) | Kitty terminal | `.config/kitty/kitty.conf` |
| [file-manager](file-manager.md) | Yazi file manager | `.config/yazi/yazi.toml` |
| [macos](macos.md) | macOS system preferences | `Makefile`, `nix/flake.nix` |
| [theme](theme.md) | Catppuccin Frappe consistency | All config files |

## Implementation Plans

| Plan | Spec | Status |
|------|------|--------|
| [shell-implementation-plan](shell-implementation-plan.md) | [shell](shell.md) | Done |
