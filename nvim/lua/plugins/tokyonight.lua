-- Active colorscheme
return {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            style = "storm",
            transparent = true,
            terminal_colors = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
                comments = { italic = true },
                keywords = { italic = true },
            },
            on_highlights = function(hl, c)
                hl.NormalFloat = { bg = c.bg_dark, fg = c.fg }
                hl.FloatBorder = { bg = c.bg_dark, fg = c.blue }
                hl.CursorLine = { bg = "#23283b" }
                hl.CursorLineNr = { fg = c.orange, bold = true }
                hl.LineNr = { fg = "#545c7e" }
                hl.Visual = { bg = "#3d4663" }
                hl.SnacksPickerBorder = { fg = "#3d4663" }
                hl.SnacksExplorerNormal = { bg = "NONE" }
                hl.SnacksExplorerBorder = { fg = "#3d4663" }
            end,
        })
        vim.cmd.colorscheme("tokyonight")
    end,
}
