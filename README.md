# dotfiles

Personal dotfiles for macOS (Apple Silicon). Manages dev tools, terminal, editor, and system preferences via nix-darwin.

## Bootstrap

```bash
curl -fsSL https://raw.githubusercontent.com/kacricon/dotfiles/master/setup.sh | sh
```

This is idempotent — re-running it applies the latest configuration without errors. It will:

1. Install Xcode Command Line Tools
2. Install Nix via Determinate Systems installer
3. Clone (or pull) this repo to `~/projects/dotfiles`
4. Run `darwin-rebuild switch`
5. Apply dotfiles to `$HOME`
