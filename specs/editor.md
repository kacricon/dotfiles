# Editor

## Overview

Neovim is the primary editor, configured with a single `init.lua` using lazy.nvim for plugin management. The setup prioritizes simplicity: no LSP (yet), no DAP, no custom statusline.

## Current State

`.config/nvim/init.lua` contains:

**Core settings:**
- Leader: `<Space>`
- Line numbers, smart indent, 4-space tabs (expandtab)
- Path-based fuzzy find (`**` in path, wildmenu)
- Tag jumping via ctags (`:MakeTags` command)

**Plugins** (lazy.nvim, auto-bootstrapped):
1. **catppuccin/nvim** — Frappe flavour
2. **telescope.nvim** (`master`) — fuzzy finder, respects `.git/`, `.venv/`, `.ruff_cache/`, compatible with Neovim 0.12 Treesitter preview APIs
3. **nvim-treesitter** (`main`) — parser/query install for: bash, c, css, go, html, javascript, lua, markdown, markdown_inline, python, query, svelte, typescript, vim, vimdoc. Highlighting is enabled with Neovim's built-in `vim.treesitter.start()` for matching filetypes.
4. **goyo.vim** — distraction-free writing
5. **vim-slime** — REPL integration targeting kitty (`slime_target = "kitty"`)
6. **vim-kitty** — kitty.conf syntax highlighting
7. **neo-tree.nvim** — file explorer (v3.x)
8. **gitsigns.nvim** — git gutter signs

**Key mappings:**
- `<C-p>` → Telescope find_files (hidden files included)
- `<leader>fg` → Telescope live_grep
- `<C-c><C-c>` → vim-slime send paragraph (normal) / region (visual)

**REPL workflow:**
vim-slime sends code from Neovim to a kitty window. Requires `allow_remote_control yes` and `listen_on unix:/tmp/kitty` in kitty.conf. Uses `~/.slime_paste` as temp file. IPython mode enabled.

**Files:** `.config/nvim/init.lua`

## Desired State

Current state is largely correct. Potential additions:

- **LSP**: consider adding `nvim-lspconfig` for Python (pyright/ruff), Go (gopls), Lua (lua_ls), TypeScript (ts_ls)
- **Completion**: if LSP is added, pair with `nvim-cmp`
- **Format on save**: via LSP or conform.nvim

These are optional enhancements, not blockers.

## Design Decisions

- **Single file**: all config lives in one `init.lua`. No splitting into `lua/` modules until complexity demands it.
- **lazy.nvim**: auto-bootstraps on first launch, no manual install step.
- **vim-slime over built-in terminal**: kitty-based REPL is faster and persists across Neovim restarts.
- **No statusline plugin**: the default statusline is sufficient.

## Dependencies

- [terminal](terminal.md) — kitty must have remote control enabled for vim-slime
- [packages](packages.md) — neovim, tree-sitter, ripgrep, universal-ctags must be installed
- [theme](theme.md) — catppuccin Frappe flavour

## Implementation Files

- `.config/nvim/init.lua`

## Verification

```bash
nix shell nixpkgs#tree-sitter -c nvim --headless "+Lazy! sync" +qa
nvim --headless -u .config/nvim/init.lua "+edit specs/editor.md" "+redraw!" +qa
nvim -c ":checkhealth" -c ":q"           # no critical warnings
nvim -c ":Telescope find_files" -c ":q"  # telescope loads
```
