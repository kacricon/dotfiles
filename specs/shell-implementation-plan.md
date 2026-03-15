# Shell Implementation Plan

Implementation checklist for specs/shell.md.

> Spec: [shell.md](shell.md)
> Created: 2026-03-15

## Overview

Apply the four changes defined in the shell spec's "Desired State" to `.zshrc`: add zoxide init, history config, basic completions, and remove the dead `killtouchbar` alias.

All dependencies are met — zoxide, nvim, timer, and terminal-notifier are installed via Nix.

## File Inventory

| File | Action |
|------|--------|
| `.zshrc` | Modify |
| `specs/shell.md` | Update (move items to Current State) |

## Phase 1: Shell config changes

> Reference: shell.md §Desired State
> File: `.zshrc`

- [x] Remove `killtouchbar` alias (line 11) — irrelevant on Apple Silicon (no Touch Bar)
- [x] Add history configuration after the locale block:
  - `HISTFILE=~/.zsh_history`
  - `HISTSIZE=10000`
  - `SAVEHIST=10000`
  - `setopt HIST_IGNORE_DUPS`
  - `setopt SHARE_HISTORY`
- [x] Add basic completion init: `autoload -Uz compinit && compinit`
- [x] Add zoxide initialization at end of file: `eval "$(zoxide init zsh)"`
  - Must come after compinit per zoxide docs

## Phase 2: Spec update

> Reference: shell.md §Current State, §Desired State

- [x] Update `specs/shell.md` "Current State" to reflect the four changes
- [x] Update "Desired State" to remove completed items

## Verification

```bash
source ~/.zshrc

# History:
echo $HISTSIZE         # → 10000
echo $SAVEHIST         # → 10000
test -n "$HISTFILE"    # exit 0

# Completions:
type compinit          # → function

# Zoxide:
type z                 # → function

# Removed:
type killtouchbar      # → not found

# Preserved (no regressions):
echo $PROMPT           # → "; "
type work              # → alias
type vim               # → alias for nvim
bindkey -l | grep -q vicmd  # vi mode active
```
