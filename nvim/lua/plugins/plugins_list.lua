-- Configurable status line
local galaxyline = { 'glepnir/galaxyline.nvim' };

local cmake = { 'Civitasv/cmake-tools.nvim'}

local tokyodark = {
    "tiagovla/tokyodark.nvim",
    config = function(_, opts)
        require("tokyodark").setup(opts)
        vim.cmd [[colorscheme tokyodark]]
    end,
}

local darkbox = {
  "timmypidashev/darkbox.nvim",
  lazy = false,
  config = function()
    require("darkbox").load()
  end
}
--
-- TypeScript tools and React support
local typescript_tools = {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
}

-- Maintained formatter runner with CLI fallback support
local conform = {
    "stevearc/conform.nvim",
    opts = {
        notify_on_error = false,
        formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            css = { "prettierd", "prettier", stop_after_first = true },
            dart = { "dart_format" },
            html = { "prettierd", "prettier", stop_after_first = true },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            javascriptreact = { "prettierd", "prettier", stop_after_first = true },
            json = { "prettierd", "prettier", stop_after_first = true },
            jsonc = { "prettierd", "prettier", stop_after_first = true },
            lua = { "stylua" },
            markdown = { "prettierd", "prettier", stop_after_first = true },
            rust = { "rustfmt" },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            typescriptreact = { "prettierd", "prettier", stop_after_first = true },
            yaml = { "prettierd", "prettier", stop_after_first = true },
        },
    },
}

-- React snippets
local friendly_snippets = {
    "rafamadriz/friendly-snippets",
    dependencies = {
        "L3MON4D3/LuaSnip",
    },
}

local just = { 'NoahTheDuke/vim-just' } 

local avante = {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
        -- provider = "openai"
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick",     -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",          -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua",          -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",    -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}


-- Allows to comment out blocks of code
local comment = {
    'numToStr/Comment.nvim',
    config = true,
    lazy = false
};

-- Basicaly a plugin dependency with utils, nothing interesting
local plenary = { 'nvim-lua/plenary.nvim' };

-- Extremely powerful fuzzy finder, can't live without it.
local telescope = {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
};

-- Self explanatory
local lsp_config = { 'neovim/nvim-lspconfig' };

-- Displays float with info who commited given line
local git_messenger = { 'rhysd/git-messenger.vim' };

local nvim_cmp = { 'hrsh7th/nvim-cmp' };

local cmp_nvim_lsp = { 'hrsh7th/cmp-nvim-lsp' };

-- Display errors/warnings/info
local trouble = {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
};

-- Latex support
local vimtex = {
    'lervag/vimtex',
    lazy = false,
};

local flutter_tools = {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    config = true,
};

-- Snippets
local luasnip = { "L3MON4D3/LuaSnip" };

-- Togglable file tree
local nvim_tree = { 'nvim-tree/nvim-tree.lua' };

-- Togglable terminal
local toggleterm = { 'akinsho/toggleterm.nvim' };

-- Opens floating window with curent buffer, to investigate some
-- code without losing contest
local detour = { "carbon-steel/detour.nvim" };

-- Snippets
local ultisnips = { 'SirVer/ultisnips' };

-- Snippets
local vim_snippets = { 'honza/vim-snippets' };

-- debugger
local nvim_dap = { 'mfussenegger/nvim-dap' };

-- debugger ui
local nvim_dap_ui = { 'rcarriga/nvim-dap-ui' };

-- Modern LuaLS helper for Neovim config files
local lazydev = {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}

-- UI helper
local dressing = {
    'stevearc/dressing.nvim',
    opts = {},
};

local todo_comments = {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
}

local which_key = {
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
}

local nvim_nio = {
    'nvim-neotest/nvim-nio'
}

return {
    avante,
    cmake,
    typescript_tools,
    just,
    conform,
    friendly_snippets,
    galaxyline,
    tokyodark,
    -- darkbox,
    comment,
    plenary,
    telescope,
    lsp_config,
    git_messenger,
    nvim_cmp,
    cmp_nvim_lsp,
    trouble,
    vimtex,
    flutter_tools,
    luasnip,
    nvim_tree,
    toggleterm,
    detour,
    ultisnips,
    vim_snippets,
    nvim_dap,
    nvim_dap_ui,
    lazydev,
    dressing,
    todo_comments,
    which_key,
    nvim_nio,
}
