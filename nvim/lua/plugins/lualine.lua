-- Statusline (replaces galaxyline)
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "echasnovski/mini.icons" },
    opts = {
        options = {
            theme = "tokyonight",
            globalstatus = true,
            component_separators = { left = " ", right = " " },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { statusline = { "snacks_dashboard" } },
        },
        sections = {
            lualine_c = { { "filename", path = 1 } },
            lualine_x = {
                { "diagnostics", symbols = { error = "E ", warn = "W ", info = "I ", hint = "H " } },
                "filetype",
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { { "filename", path = 1 } },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
    },
}
