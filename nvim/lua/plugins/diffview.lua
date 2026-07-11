-- Git diff review
return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "echasnovski/mini.icons" },
    cmd = {
        "DiffviewOpen",
        "DiffviewClose",
        "DiffviewToggleFiles",
        "DiffviewFocusFiles",
        "DiffviewRefresh",
        "DiffviewFileHistory",
    },
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open git diff review" },
        { "<leader>gD", "<cmd>DiffviewOpen -- %<cr>", desc = "Open current file diff" },
        { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close git diff review" },
    },
    opts = {
        enhanced_diff_hl = true,
        view = {
            default = {
                layout = "diff2_horizontal",
                winbar_info = true,
            },
            merge_tool = {
                layout = "diff3_horizontal",
                disable_diagnostics = true,
                winbar_info = true,
            },
        },
        file_panel = {
            listing_style = "tree",
            win_config = {
                position = "left",
                width = 32,
            },
        },
    },
}
