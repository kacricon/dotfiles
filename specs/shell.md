# Shell

## Overview

Zsh is the login shell, configured for minimalism: vi-mode keybindings, a two-character prompt, and a handful of aliases. No plugin manager, no framework.

## Current State

`.zshrc` contains:

- **Locale**: `LC_ALL=en_US.UTF-8`
- **History**: `HISTFILE=~/.zsh_history`, `HISTSIZE=10000`, `SAVEHIST=10000`, `HIST_IGNORE_DUPS`, `SHARE_HISTORY`
- **Completions**: `autoload -Uz compinit && compinit`
- **Prompt**: `; ` (semicolon + space)
- **Vi mode**: `bindkey -v` with NORMAL mode indicator in RPROMPT, `KEYTIMEOUT=1`
- **Aliases**:
  - `vim` → `nvim`
  - `gs` → `git status`
  - `newvenv` → `python3 -m venv .venv`
  - `venv` → `source .venv/bin/activate`
  - `reqs` → `pip install -r requirements.txt`
  - `work` → 25-minute Pomodoro timer with notification (Portuguese messages)
  - `rest` → 5-minute break timer with notification
- **zoxide**: `eval "$(zoxide init zsh)"` at end of file (after compinit)

**Files:** `.zshrc`

## Desired State

All previously planned items are implemented. No pending changes.

Everything stays as-is. No oh-my-zsh, no starship, no plugin managers.

## Design Decisions

- **No framework**: raw zsh config is simpler and faster to load.
- **Vi mode is non-negotiable**: this is a vi-centric setup.
- **Portuguese in Pomodoro messages**: intentional, keep them.
- **Minimal prompt**: `; ` is fast and unobtrusive. No git branch, no path — use `pwd` or the terminal title if needed.

## Dependencies

- [packages](packages.md) — `nvim`, `timer`, `terminal-notifier`, `zoxide` must be installed

## Implementation Files

- `.zshrc`

## Verification

```bash
# Source and test:
source ~/.zshrc
echo $PROMPT          # → "; "
which nvim            # alias works
work                  # timer starts (Ctrl-C to cancel)
```
