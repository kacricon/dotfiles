# Hermes

## Overview

Hermes Agent is the AI assistant installed via the `hermes-agent` Nix flake. Its configuration — skills, memories, and core identity — is versioned in this dotfiles repo under `.hermes/` and applied alongside other dotfiles via `make apply_dotfiles`.

## Current State

`.hermes/` is tracked in this repo and included in the `FILES` variable in `Makefile`, so `make apply_dotfiles` copies it to `~/.hermes/` on any machine.

**Tracked files:**
- `.hermes/SOUL.md` — core agent identity and persona
- `.hermes/config.yaml` — Hermes configuration
- `.hermes/memories/` — persistent memory (user profile and agent notes)
- `.hermes/skills/` — reusable procedural workflows

**Excluded from repo** (via `.hermes/.gitignore`):
- `auth.json`, `auth.lock` — platform credentials (Telegram, WhatsApp, etc.)
- `state.db*` — runtime database
- `logs/`, `cron/`, `sessions/`, `sandboxes/`, `platforms/` — ephemeral runtime data

**Files:** `.hermes/`, `Makefile`

## Desired State

No remaining delta — current state matches desired state.

## Design Decisions

- **Dotfiles-native**: Hermes config follows the same `cp -r` pattern as `.zshrc` and `.config` — no special tooling required.
- **Credentials excluded**: `auth.json` is never committed; platform re-authentication is a manual step after bootstrap.
- **Skills drift over time**: `.hermes/skills/` and `.hermes/memories/` accumulate changes as Hermes learns. These should be periodically synced back to the repo and committed to keep the dotfiles up to date.

## Dependencies

- [packages](packages.md) — `hermes-agent` must be installed via the Nix flake before Hermes can run
- [bootstrap](bootstrap.md) — `make apply_dotfiles` copies `.hermes/` to `~/.hermes/`

## Implementation Files

- `.hermes/`
- `Makefile`

## Verification

```bash
# Hermes binary available
which hermes

# Config applied
diff ~/.hermes/SOUL.md ~/projects/dotfiles/.hermes/SOUL.md    # no diff
diff ~/.hermes/config.yaml ~/projects/dotfiles/.hermes/config.yaml  # no diff

# Credentials not tracked
grep -r "auth.json" ~/projects/dotfiles/.hermes/  # no output
```
