-- Git hunks in-buffer (nav ]h/[h, actions under <leader>h)
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "▌" },
            change = { text = "▌" },
            delete = { text = "▸" },
            topdelete = { text = "▾" },
            changedelete = { text = "▌" },
            untracked = { text = "▌" },
        },
        signs_staged = {
            add = { text = "│" },
            change = { text = "│" },
            delete = { text = "╴" },
            topdelete = { text = "╴" },
            changedelete = { text = "│" },
            untracked = { text = "│" },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        show_deleted = false,
        current_line_blame = false,
        preview_config = {
            border = "rounded",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
        on_attach = function(bufnr)
            local gs = require("gitsigns")
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
            end
            -- navigation
            map("n", "]h", function()
                gs.nav_hunk("next")
            end, "Next git hunk")
            map("n", "[h", function()
                gs.nav_hunk("prev")
            end, "Prev git hunk")
            -- actions (all under <leader>h = hunk)
            map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
            map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
            map("n", "<leader>ha", gs.stage_hunk, "Accept hunk")
            map("n", "<leader>hx", gs.reset_hunk, "Reject hunk")
            map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
            map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
            map("n", "<leader>hA", gs.stage_buffer, "Accept buffer")
            map("n", "<leader>hX", gs.reset_buffer, "Reject buffer")
            map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
            map("n", "<leader>hb", function()
                gs.blame_line({ full = true })
            end, "Blame line")
            map("n", "<leader>hd", gs.diffthis, "Diff this")
            map("n", "<leader>htb", gs.toggle_current_line_blame, "Toggle line blame")
            map("n", "<leader>htd", gs.toggle_deleted, "Toggle deleted")
        end,
    },
}
