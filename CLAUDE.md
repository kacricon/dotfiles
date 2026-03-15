# CLAUDE.md

Specs describe intent; code describes reality. Always read the code before assuming a spec is implemented. When a spec's "Current State" diverges from the code, the code wins — update the spec.

## What This Is

Personal dotfiles for macOS (Apple Silicon). Manages dev tools, terminal, editor, and system preferences.

## Specs

All design intent lives in `specs/`. Start there: [specs/README.md](specs/README.md)

## Quick Reference

```bash
make all                  # rebuild nix-darwin + copy dotfiles to $HOME
make rebuild              # nix-darwin rebuild only
make apply_dotfiles       # copy .zshrc and .config to $HOME (with backup)
```

## Architecture

```
.
├── CLAUDE.md                        # this file
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
- **Branch**: `master` is main; `test/nix` is the active migration branch
- **Paths**: XDG-style (`~/.config/<tool>/`)
- **Editor**: Neovim, single `init.lua`, lazy.nvim
- **Shell**: raw zsh, vi-mode, no framework
- **Commits**: imperative mood, lowercase, English. Never add "Co-Authored-By" or similar attribution lines.

## Agent Workflow

When picking up work from a spec:

1. **Read the spec** — understand desired vs current state
2. **Read the code** — verify the spec's "Current State" is accurate; fix the spec if not
3. **Create an implementation plan** — list files to change, dependencies, and verification steps
4. **Implement** — make the changes
5. **Verify** — run the spec's verification commands
6. **Update the spec** — move items from "Desired State" to "Current State" once implemented
7. **Update downstream references** — update any files that reference changed functionality: Makefile targets, CLAUDE.md quick reference/architecture, other specs, and specs/README.md

Never implement directly from a spec without reading the actual code first. Specs can be stale.

## Creating Implementation Plans

Implementation plans live in `specs/` as `<spec_name>-implementation-plan.md` (e.g., `specs/shell-implementation-plan.md`).

Structure:

- **Overview**: what and why
- **File inventory**: table of files to create, modify, or delete
- **Phases**: numbered phases with checklist items (`- [ ]`), each referencing the spec section it implements
- **Verification**: concrete commands that prove the changes work

Guidelines:

- Reference the spec by name and section (e.g., "shell.md §Desired State")
- Identify cross-spec dependencies (e.g., packages must exist before shell can use them)
- Keep plans small — one logical change per plan
- Mark items `[x]` as they are completed
