# Neovim config

Lua config built on lazy.nvim. `init.lua` loads `lua/init.lua` (options, diagnostics), then plugins, LSP, DAP and keymaps.

`lua/plugins/plugins_list.lua` is only a list of specs. Any plugin that needs more than a few lines of setup gets its own file under `lua/plugins/`.

Highlights:

- snacks.nvim: picker, file explorer, terminal, lazygit
- blink.cmp completion (super-tab preset) and treesitter
- conform.nvim format-on-save (toggle with `:FormatDisable`)
- LSP and debugging for Dart/Flutter, Rust, C++, Lua and LaTeX
- `lua/codex_agent.lua`: Codex CLI in a terminal split, prompts from visual selection, inline review of AI edits with per-hunk accept/reject

Machine-local or private additions go in `lua/private/` (gitignored, loaded last when present).

Keybinding reference: [KEYMAPS.md](KEYMAPS.md).
