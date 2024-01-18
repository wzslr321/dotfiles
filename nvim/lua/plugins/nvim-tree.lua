require "nvim-tree".setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})
