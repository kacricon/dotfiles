# AGENTS.md

Specs describe intent; code describes reality. Always read the code before assuming a spec is implemented. When a spec's "Current State" diverges from the code, the code wins — update the spec.

## What This Is

Personal dotfiles for macOS (Apple Silicon). Manages dev tools, terminal, editor, and system preferences.

## Specs

All design intent lives in `specs/`. Start there: [specs/README.md](specs/README.md)

## Quick Reference

```bash
sh setup.sh               # full bootstrap (fresh Mac or idempotent re-run)
make all                  # rebuild nix-darwin + sync managed dotfiles to $HOME
make rebuild              # nix-darwin rebuild only
make update_nixpkgs       # update the pinned nixpkgs flake input
make upgrade              # update nixpkgs + rebuild nix-darwin
make apply_dotfiles       # sync .zshrc and managed .config dirs to $HOME (with backup)
```

## Architecture

```
.
├── AGENTS.md                        # this file
├── setup.sh                         # bootstrap script (curl | sh)
├── specs/                           # design specs (intent, not implementation)
├── Makefile                         # setup orchestration
├── .zshrc                           # shell config
├── .config/
│   ├── nvim/init.lua                # neovim (lazy.nvim, single file)
│   ├── kitty/kitty.conf             # terminal emulator
│   ├── kitty/current-theme.conf     # catppuccin frappe
│   └── yazi/yazi.toml               # file manager
└── nix/flake.nix                    # nix-darwin system config
```

## Conventions

- **Theme**: Catppuccin Frappe everywhere
- **Packages**: Nix-darwin first, Homebrew only for casks/mas/unavailable taps
- **Branch**: `master` is main; `test/nix` is a dormant historical branch from the nix migration
- **Paths**: XDG-style (`~/.config/<tool>/`)
- **Editor**: Neovim, single `init.lua`, lazy.nvim
- **Shell**: raw zsh, vi-mode, no framework
- **Commits**: imperative mood, lowercase, English. Never add "Co-Authored-By" or similar attribution lines.

## Agent Workflow

When picking up work from a spec:

1. **Read the spec** — understand desired vs current state
2. **Read the code** — verify the spec's "Current State" is accurate; fix the spec if not
3. **Implement** — make the changes
4. **Verify** — run the spec's verification commands
5. **Update the spec** — move items from "Desired State" to "Current State" once implemented
6. **Update downstream references** — update any files that reference changed functionality: Makefile targets, AGENTS.md quick reference/architecture, other specs, and specs/README.md

Never implement directly from a spec without reading the actual code first. Specs can be stale.
