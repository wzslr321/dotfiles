-- Plugin list - specs only. Any plugin whose config is more than a few
-- lines lives in its own file under lua/plugins/ (nvim-dap.lua is loaded
-- separately from init.lua).
return {
    -- Core
    require("plugins.blink"),
    { "rafamadriz/friendly-snippets" },
    require("plugins.lualine"),
    require("plugins.snacks"),
    require("plugins.treesitter"),
    { "echasnovski/mini.icons", lazy = true, opts = {} },
    { "echasnovski/mini.surround", event = "VeryLazy", opts = {} },
    { "echasnovski/mini.pairs", event = "VeryLazy", opts = {} },
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    -- treesitter-powered: af/if=function, ac/ic=class, aa/ia=argument
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
                    a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
                },
            }
        end,
    },
    {
        "stevearc/oil.nvim",
        opts = {
            keymaps = {
                ["<leader>."] = { "actions.toggle_hidden", mode = "n" },
            },
        },
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        },
    },
    { "nvim-lua/plenary.nvim" },

    -- Colorschemes (tokyonight active; others kept for :colorscheme swaps)
    require("plugins.tokyonight"),
    { "rebelot/kanagawa.nvim", lazy = true },
    { "catppuccin/nvim", name = "catppuccin", lazy = true },

    -- LSP & formatting
    { "neovim/nvim-lspconfig" },
    require("plugins.conform"),
    { "folke/trouble.nvim", dependencies = { "echasnovski/mini.icons" } },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- Languages
    { "Civitasv/cmake-tools.nvim" },
    { "NoahTheDuke/vim-just" },
    { "lervag/vimtex", lazy = false },
    {
        "akinsho/flutter-tools.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            lsp = {
                color = { enabled = true },
                settings = {
                    showTodos = true,
                    completeFunctionCalls = true,
                    analysisExcludedFolders = {},
                },
            },
        },
    },

    -- Git
    { "rhysd/git-messenger.vim" },
    require("plugins.diffview"),
    require("plugins.gitsigns"),

    -- Debugger
    { "mfussenegger/nvim-dap" },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        opts = {},
    },
    { "nvim-neotest/nvim-nio" },

    -- UI & navigation
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
    { "carbon-steel/detour.nvim" },
    { "Bekaboo/dropbar.nvim", event = "VeryLazy", opts = {} },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        opts = { file_types = { "markdown" } },
    },
}
