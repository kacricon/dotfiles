# dotfiles

Personal dotfiles for macOS (Apple Silicon). Manages dev tools, terminal, editor, and system preferences via nix-darwin.

## Bootstrap

```bash
curl -fsSL https://raw.githubusercontent.com/kacricon/dotfiles/master/setup.sh | sh
```

This is idempotent — re-running it applies the latest configuration without errors. It will:

1. Install Xcode Command Line Tools
2. Install Nix via Determinate Systems installer
3. Install Homebrew
4. Clone (or fast-forward) this repo to `~/projects/dotfiles`
5. Run `sudo -H darwin-rebuild switch` (bootstrapping `darwin-rebuild` from the flake on first run)
6. Apply managed dotfiles to `$HOME`

## Maintenance

```bash
make rebuild         # rebuild from the pinned flake.lock
make update_nixpkgs  # refresh the nixpkgs pin
make upgrade         # update nixpkgs, then rebuild
```
