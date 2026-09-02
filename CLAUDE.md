# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for macOS. Source-based (no stow/symlinks) - tools reference configs directly from `~/dotfiles/`. No build or install scripts; tools are installed externally via Homebrew.

Docs style: plain human voice, never use em dashes (they read as AI-generated); explain tools instead of name-dropping them.

## Structure

- **nvim/** - Neovim config (Lua-based, lazy.nvim plugin manager); keybinding reference in `nvim/KEYMAPS.md`
- **zsh/.zshrc** - Zsh shell config (Oh My Zsh, Starship prompt, modern CLI tools)
- **zellij/** - Zellij terminal workspace (KDL config + `zas` session-picker helper)
- **cmux/cmux.json** - cmux workspace settings and familiar Ghostty/Zellij keybindings
- **ghostty/config** - Ghostty terminal settings
- **starship.toml** - Starship prompt config (loaded via `STARSHIP_CONFIG` in .zshrc)
- **lazygit/config.yml** - Lazygit TUI config

## Neovim Architecture

Entry point: `nvim/init.lua` → requires `lua/init.lua` (settings, keymaps, diagnostics).

Plugin system uses **lazy.nvim** (auto-bootstraps in `lua/plugins.lua`). `lua/plugins/plugins_list.lua` is a spec list only - any plugin config longer than a few lines lives in its own file under `lua/plugins/` (blink, snacks, treesitter, tokyonight, conform, diffview, gitsigns, lualine; keep it that way). The DAP config (`lua/plugins/nvim-dap.lua`) is loaded separately from `init.lua`.

Key plugin consolidation (2026 update):
- **snacks.nvim** replaces telescope, nvim-tree, toggleterm, dressing, nvim-notify
- **blink.cmp** (super-tab preset) replaces nvim-cmp + cmp-nvim-lsp + LuaSnip
- **lualine.nvim** replaces galaxyline

Custom modules:
- **lua/codex_agent.lua** - Codex CLI integration: terminal split (`codex --no-alt-screen`), prompts from visual selection, and an inline visual-review mode (extmark-rendered hunks with accept/reject). Keymaps under `<leader>a*` / `<leader>c*`.
- **lua/private/** (gitignored) - machine-local / private config overlay, loaded last from `nvim/init.lua` via `pcall` (absent on fresh clones). Anything tied to private/work repos - project tooling, extra LSP schemas (merged via `vim.lsp.config`), keymaps - goes here, NEVER in tracked files.

LSP configs: `lua/lsp.lua` - always: lua_ls, clangd, digestif; rust_analyzer via ra-multiplex with plain-rust-analyzer fallback; if installed: bashls, dockerls, ruff, basedpyright/pyright, yamlls.
Formatting: conform.nvim with format-on-save (clang-format, rustfmt, dart_format, prettierd/prettier, stylua, ruff, shfmt); stylua config in `nvim/.stylua.toml`.
DAP: `lua/plugins/nvim-dap.lua` (lldb-dap for Rust, Flutter via FVM with multi-flavor support; reads `FLUTTER_PATH`/`DART_PATH` from the shell env). Treat this file as hands-off - the Flutter debug setup is hard-won.

After changing keymaps, update `nvim/KEYMAPS.md` to match.

## Zsh Configuration

`zsh/.zshrc` initializes Homebrew first, then sets up PATH for Flutter/Dart (via fvm), LLVM, Java, Android, Ruby, .NET, etc. Uses zsh-vi-mode plugin and Starship (`STARSHIP_CONFIG` points into this repo). Modern CLI aliases: eza→ls, bat→cat, zoxide→cd, atuin→history. A `codex()` wrapper adds `--no-alt-screen` to interactive Codex TUI invocations and uses cmux's per-session wrapper when `CMUX_SURFACE_ID` is present. Paseo's bundled CLI is added to PATH when Paseo.app exists. Zellij is retained as a fallback and attached manually via `zas` (no auto-attach).

Private hooks (both gitignored): `~/.zshenv.local` (secrets, sourced first) and `zsh/.zshrc.local` (machine-local shell config, sourced last).

## Git Workflow

- Working branch: `2026`, PRs target `main`
- `.gitignore` excludes: lazy-lock.json, .DS_Store, .luarc.json, .idea, LaTeX build artifacts
