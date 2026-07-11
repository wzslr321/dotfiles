<!--
AI-Provenance:
  model: claude-fable-5
  harness: Claude Code
-->

# Neovim Keymaps

Personal keybinding reference, generated from the live config (2026-07).

- **Leader** = `Space`
- **Local leader** = `'` (apostrophe - used by LaTeX/vimtex)
- Text objects work after an operator (`d`, `c`, `y`, `v`). Below, `<leader>` = `Space`.

---

## Files, search & navigation

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Grep (live search) |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>e` | File explorer (snacks) |
| `-` | Open parent dir in Oil (edit filesystem as a buffer) |
| `<leader>.` | Toggle hidden files (inside Oil) |
| `<leader>tr` | Terminal (toggle) |
| `<leader>lg` | Lazygit |
| `<leader>?` | Buffer-local keymaps (which-key popup) |

## LSP - code intelligence

Neovim 0.11 built-in defaults + a few custom maps.

| Key | Action |
|-----|--------|
| `K` | Hover docs |
| `grn` | Rename symbol |
| `gra` | Code action (normal & visual) |
| `grr` | References |
| `gri` | Implementation |
| `gO` | Document symbols |
| `<C-s>` | Signature help (insert mode) |
| `gD` | Declaration *(custom)* |
| `<leader>D` | Type definition *(custom)* |
| `gr` | References via Trouble *(custom)* |
| `<leader>f` / `<leader>cf` | Format buffer (conform, LSP fallback) |
| `<leader>df` | `dart format -l 120` on current file |
| `<leader>ih` | Toggle inlay hints (inline types & param names) |

> Formatting also runs **on save**. Toggle with `:FormatDisable` / `:FormatEnable` (`:FormatDisable!` = current buffer only).
> `gr` overlaps the `gr…` LSP prefix - after a brief `timeoutlen` pause `gr` opens Trouble; type `grr` quickly for the built-in.

## Diagnostics

| Key | Action |
|-----|--------|
| `]d` / `[d` | Next / prev diagnostic |
| `<C-w>d` | Show diagnostics under cursor |
| `<leader>gl` | Diagnostic float *(custom)* |
| `<leader>xa` | Toggle diagnostics (workspace) - Trouble |
| `<leader>xw` | Open diagnostics - Trouble |
| `<leader>xd` | Buffer diagnostics - Trouble |
| `<leader>xq` | Quickfix list - Trouble |
| `<leader>xl` | Location list - Trouble |

## Git

gitsigns (in-buffer) + diffview + lazygit. `git-messenger` is also installed for commit-under-cursor popups.

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / prev hunk |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk |
| `<leader>ha` / `<leader>hx` | Accept / reject hunk (aliases for stage / reset) |
| `<leader>hS` / `<leader>hR` | Stage / reset whole buffer |
| `<leader>hA` / `<leader>hX` | Accept / reject whole buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hd` | Diff this |
| `<leader>htb` | Toggle inline line-blame |
| `<leader>htd` | Toggle deleted |
| `<leader>gd` | Diffview - review full working-tree diff |
| `<leader>gD` | Diffview - current file only |
| `<leader>gq` | Diffview - close review |
| `<leader>lg` | Lazygit (full TUI) |

## Treesitter - selection & movement

| Key | Action |
|-----|--------|
| `<C-space>` | Start / expand selection to next node |
| `<BS>` | Shrink selection (in visual) |
| `]f` / `[f` | Next / prev function start |
| `]c` / `[c` | Next / prev class start |

## Text objects

mini.ai (treesitter-powered) + built-ins.

| Object | Meaning |
|--------|---------|
| `af` / `if` | Function - outer / inner |
| `ac` / `ic` | Class - outer / inner |
| `aa` / `ia` | Argument / parameter |
| `a)` `a]` `a}` `a"` `a'` `` a` `` | Brackets / quotes (use `i` for inner) |
| `at` / `it` | Tag (HTML/XML) |
| `an` / `in` | The **next** textobject |
| `al` / `il` | The **last** textobject |

## Editing

| Key | Action |
|-----|--------|
| `gc` / `gcc` | Toggle comment - motion / current line |
| `sa` | Add surrounding (`saiw)` or visual `sa)`) |
| `sd` | Delete surrounding |
| `sr` | Replace surrounding |
| `sf` / `sF` | Find surrounding - right / left |
| `sh` | Highlight surrounding |
| - | `(` `[` `{` `"` `'` `` ` `` auto-close (mini.pairs) |

## Completion - blink.cmp (insert mode, `super-tab` preset)

| Key | Action |
|-----|--------|
| `<Tab>` | **Accept** selected item (or jump to next snippet slot) |
| `<S-Tab>` | Previous snippet slot |
| `<C-n>` / `<C-p>` (or arrows) | Next / prev item |
| `<C-space>` | Open / toggle completion + docs |
| `<C-e>` | Dismiss |
| `<C-b>` / `<C-f>` | Scroll docs up / down |

> Ghost text previews the top match inline; function signature help pops up while typing call arguments.

## Debugging - DAP

| Key | Action |
|-----|--------|
| `<leader>dbp` | Toggle breakpoint |
| `<leader>dc` | Continue / start |
| `<leader>dtr` | Toggle REPL |
| `<leader>dut` | Toggle DAP UI |
| `<leader>due` | Eval value (hover) |
| `<leader>duf` | Float element |

> **Rust**: resolves the executable from `cargo build --build-plan`, falls back to a path prompt.
> **Flutter**: choose a config (`Launch Flutter | Development / Local / Production / Staging`) then pick a device.

## Windows, splits & terminal

| Key | Action |
|-----|--------|
| `<leader>rh` / `<leader>rl` | Vertical resize − / + |
| `<leader>ri` / `<leader>rj` | Horizontal resize + / − |
| `<C-w>h/j/k/l` *(in terminal)* | Leave terminal → move to window |
| `<Esc>` *(in terminal)* | Exit terminal mode |
| `<leader>dd` | Detour - open current buffer in a float |

## Codex (`lua/codex_agent.lua`)

| Key | Action |
|-----|--------|
| `<leader>a?` | Action menu - normal mode; in visual mode includes the selection |
| `<leader>ac` | Open / focus Codex terminal |
| `<leader>ar` | Resume last Codex session (`codex resume --last`) |
| `<leader>ab` | Send current buffer path to Codex |
| `<leader>as` *(visual)* | Ask Codex about selection (starts inline visual review) |
| `<leader>av` | `codex review` |
| `<leader>aa` | `codex apply` - apply latest Codex diff |
| `<leader>ad` | Review Codex/git changes (Diffview) |

**Inline visual review** (active after `<leader>as`; refreshes on focus-gain):

| Key | Action |
|-----|--------|
| `<leader>ca` | Accept hunk under cursor |
| `<leader>cx` | Reject hunk (restore original lines) |
| `<leader>cr` | Refresh / focus reviewed file |
| `<leader>aR` | Disable visual review |

**Inside the Codex terminal:** `<C-s>` scroll mode · `q` back to input · `<C-g>` focus reviewed file.

## LaTeX - vimtex (local leader `'`)

| Key | Action |
|-----|--------|
| `'ll` | Compile (toggle continuous) |
| `'lv` | View PDF (forward search → Skim) |
| `'lk` / `'lK` | Stop / stop all |
| `'lc` / `'lC` | Clean / clean full (aux files) |
| `'le` | Errors (quickfix) |
| `'lo` | Compiler output |
| `'lt` / `'lT` | TOC open / toggle |
| `'lg` / `'lG` | Status / status all |
| `'li` / `'lI` | Info / info full |
| `'lm` | List insert-mode math maps |
| `'ls` | Toggle main file |
| `'lx` / `'lX` | Reload / reload state |
| `'la` | Context menu |

**Text objects:** `ac/ic` command · `ad/id` delimiter · `ae/ie` environment · `a$/i$` math · `aP/iP` section · `am/im` item
**Motions:** `]]` `[[` section · `]m` `[m` environment · `]n` `[n` math · `%` matching pair
**Surround / toggle:** `dse`/`cse` environment · `dsc`/`csc` command · `tsc` toggle `*` · `tsf` toggle fraction · `<F6>` surround line in env · `<F7>` create command · `<F8>` add delimiter modifier
Full list: `:h vimtex-default-mappings`

---

## Handy built-ins (Neovim defaults)

| Key | Action |
|-----|--------|
| `[b` / `]b` | Prev / next buffer |
| `[q` / `]q` | Prev / next quickfix |
| `[<Space>` / `]<Space>` | Add blank line above / below |
| `gx` | Open file/URL under cursor with system handler |

> To regenerate this reference after config changes, dump live maps with
> `:lua for _,m in ipairs(vim.api.nvim_get_keymap('n')) do print(m.lhs, m.desc or m.rhs) end`
