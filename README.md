<h3 align="center">Dotfiles</h3>

Personal macOS dotfiles — source-based: tools read their configs straight from `~/dotfiles/`, no symlink farm, no install scripts.

### Stack

- Terminal: [Ghostty](https://ghostty.org)
- Editor: [Neovim](https://neovim.io) — keybinding reference in [`nvim/KEYMAPS.md`](nvim/KEYMAPS.md)
- Shell: Zsh ([Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)) + [Starship](https://starship.rs) prompt
- Terminal workspace: [Zellij](https://zellij.dev)
- Git TUI: [Lazygit](https://github.com/jesseduffield/lazygit)
- Modern CLI: eza · bat · zoxide · atuin · delta

### Layout

| Path | What |
|------|------|
| `nvim/` | Neovim — lazy.nvim, snacks, blink.cmp, LSP/DAP, Codex integration |
| `zsh/.zshrc` | Shell setup, PATHs, aliases |
| `zellij/` | Zellij config + `zas` session picker |
| `ghostty/config` | Terminal settings |
| `starship.toml` | Prompt |
| `lazygit/config.yml` | Lazygit |

For some detailed information, you can check out my post
[My environment setup for Flutter development](https://wiktorzajac.me/posts/flutter-nvim/)
