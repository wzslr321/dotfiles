<h3 align="center">Dotfiles</h3>

Personal macOS dotfiles. Tools read their configs directly from `~/dotfiles/`, so there is no install script and almost nothing to symlink. Setup is a `git clone` and two symlinks.

<!--
Screenshots: drop PNGs into assets/ and uncomment.

<p align="center">
  <img src="assets/terminal.png" width="90%" alt="Ghostty running Zellij with the Starship prompt">
</p>
<p align="center">
  <img src="assets/nvim.png" width="90%" alt="Neovim">
</p>
-->

## What's inside

| Path | Tool | Role |
|------|------|------|
| `nvim/` | [Neovim](https://neovim.io) | Editor. Lua config on lazy.nvim, LSP and debugging for Dart/Flutter, Rust, C++ and LaTeX, plus a custom [Codex CLI](https://github.com/openai/codex) integration. Details in [`nvim/README.md`](nvim/README.md), all keybindings in [`nvim/KEYMAPS.md`](nvim/KEYMAPS.md) |
| `zsh/.zshrc` | Zsh | Shell config: PATH setup, aliases, plugins ([Oh My Zsh](https://ohmyz.sh), zsh-vi-mode) |
| `ghostty/config` | [Ghostty](https://ghostty.org) | Terminal emulator settings (font, theme, keybinds) |
| `zellij/` | [Zellij](https://zellij.dev) | Terminal multiplexer: tabs, panes and detachable sessions inside one terminal window. `zas` is a small helper that lists sessions and attaches to the one you pick |
| `starship.toml` | [Starship](https://starship.rs) | Shell prompt (git status, language versions, command duration) |
| `lazygit/config.yml` | [Lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |

Everything shares one look: tokyonight-storm colors across Ghostty, Neovim, Zellij and Starship.

## Replaced classics

`.zshrc` swaps a few standard commands for modern equivalents. If you don't know these tools, each one is worth a look on its own:

| Instead of | Using | What you gain |
|------------|-------|---------------|
| `ls` | [eza](https://github.com/eza-community/eza) | colors, icons, a git-status column, `lt` for a tree view |
| `cat` | [bat](https://github.com/sharkdp/bat) | syntax highlighting and line numbers |
| `cd` between projects | [zoxide](https://github.com/ajeetdsouza/zoxide) | `z dot` jumps to `~/dotfiles` from anywhere; it remembers the directories you actually use |
| `Ctrl-R` history search | [atuin](https://atuin.sh) | full-text searchable shell history in SQLite, optionally synced between machines |
| `git diff` pager | [delta](https://github.com/dandavison/delta) | side-by-side, syntax-highlighted diffs (git config snippet in the comments of `.zshrc`) |

## Setup

Clone to `~/dotfiles` (paths assume this location) and link the two configs that need linking:

```sh
git clone https://github.com/wzslr321/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/ghostty/config ~/Library/'Application Support'/com.mitchellh.ghostty/config
```

Zellij, Starship and the rest need no linking; `.zshrc` points them at the repo through `ZELLIJ_CONFIG_DIR` and `STARSHIP_CONFIG`.

The tools themselves come from Homebrew:

```sh
brew install neovim zellij starship lazygit eza bat zoxide atuin git-delta
```

Neovim installs its plugins automatically on first start.

## Private config

Anything machine-specific or tied to private repos stays out of git, in overlays that load automatically when present:

- `~/.zshenv.local`, secrets and tokens, sourced first
- `zsh/.zshrc.local`, machine-local shell config, sourced last
- `nvim/lua/private/`, local Neovim config (project tooling, extra LSP schemas), loaded last from `init.lua`
