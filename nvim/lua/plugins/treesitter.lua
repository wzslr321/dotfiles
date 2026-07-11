-- Treesitter (syntax highlighting, indentation, textobjects)
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c",
                "cpp",
                "css",
                "dockerfile",
                "rust",
                "dart",
                "html",
                "javascript",
                "lua",
                "luadoc",
                "vim",
                "vimdoc",
                "query",
                "bash",
                "markdown",
                "markdown_inline",
                "yaml",
                "json",
                "jsonc",
                "toml",
                "diff",
                "gitcommit",
                "regex",
                "python",
            },
            auto_install = true,
            highlight = {
                enable = true,
                -- vimtex owns LaTeX syntax; keep treesitter out of .tex files
                disable = { "latex" },
            },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                    },
                },
            },
        })
    end,
}
