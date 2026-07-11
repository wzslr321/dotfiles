-- Completion (replaces nvim-cmp + cmp-nvim-lsp + LuaSnip)
return {
    "saghen/blink.cmp",
    version = "*",
    opts = {
        -- super-tab: <Tab> accepts / jumps snippets, <S-Tab> back, <C-n>/<C-p> or arrows navigate
        keymap = { preset = "super-tab" },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            -- inline preview of the top completion (LSP-driven, not AI)
            ghost_text = { enabled = true },
            documentation = { auto_show = true, auto_show_delay_ms = 200 },
            menu = { border = "rounded" },
        },
        -- show function signature while typing call arguments
        signature = { enabled = true },
    },
}
