local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        'andweeb/presence.nvim',
        lazy = false,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    },
    {
        'vim-airline/vim-airline'
    },
    -- CONFIGURE KEYMAPS FOR TELESCOPE
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.3',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'neovim/nvim-lspconfig',
    },
    {
        'hrsh7th/nvim-cmp',
    },
    {
        'hrsh7th/cmp-nvim-lsp',
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },
    {
        'lervag/vimtex',
        lazy = false,
    },
    {
        'akinsho/flutter-tools.nvim',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim',
        },
        config = true,
    },
    {
        "L3MON4D3/LuaSnip",
    },
    {
        'nvim-tree/nvim-tree.lua'
    },
    { 'akinsho/toggleterm.nvim', opts = {} },
    {
        'simrat39/rust-tools.nvim',
    },
    {
        "carbon-steel/detour.nvim",
    },
    {
        'SirVer/ultisnips',
    },
    {
        'honza/vim-snippets',
    },
    {
        'mfussenegger/nvim-dap',
    }
})

require "toggleterm".setup {}
require "luasnip.loaders.from_snipmate".lazy_load()


require("flutter-tools").setup {
    lsp = {
        color = {
            enabled = true,
        },
        settings = {
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = {},
        }
    }

}

require "presence".setup({
    auto_update = true,
    main_image = "file",
    enable_line_number = true,
    editing_text = "Editing...",
})

local dap = require('dap')

dap.adapters.dart = {
    type = 'executable',
    command = 'dart',
    args = { 'debug_adapter' }
}

dap.adapters.flutter = {
    type = 'executable',
    command = 'flutter',
    args = { 'debug_adapter' }
}

dap.set_log_level('TRACE')
dap.configurations.dart = {
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Development",
        dartSdkPath = "/Users/wiktor.zajac/fltuter/bin/dart",
        flutterSdkPath = "/Users/wiktor.zajac/flutter/bin/flutter",
        program = "${workspaceFolder}/lib/main_development.dart",
        cwd = "${workspaceFolder}",
        toolArgs = { "-d", "7029C1E6-5CE5-4A6A-AFF2-80E0AD32D792", "--flavor", "development" }
    },
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Mock",
        dartSdkPath = "/Users/wiktor.zajac/fltuter/bin/dart",
        flutterSdkPath = "/Users/wiktor.zajac/flutter/bin/flutter",
        program = "${workspaceFolder}/lib/main_mock.dart",
        cwd = "${workspaceFolder}",
        toolArgs = { "-d", "7029C1E6-5CE5-4A6A-AFF2-80E0AD32D792", "--flavor", "development" }
    },
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Production",
        dartSdkPath = "/Users/wiktor.zajac/fltuter/bin/dart",
        flutterSdkPath = "/Users/wiktor.zajac/flutter/bin/flutter",
        program = "${workspaceFolder}/lib/main_production.dart",
        cwd = "${workspaceFolder}",
        toolArgs = { "-d", "7029C1E6-5CE5-4A6A-AFF2-80E0AD32D792", "--flavor", "production" }
    },
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Staging",
        dartSdkPath = "/Users/wiktor.zajac/fltuter/bin/dart",
        flutterSdkPath = "/Users/wiktor.zajac/flutter/bin/flutter",
        program = "${workspaceFolder}/lib/main_staging.dart",
        cwd = "${workspaceFolder}",
        toolArgs = { "-d", "7029C1E6-5CE5-4A6A-AFF2-80E0AD32D792", "--flavor", "staging" }
    }
}

vim.diagnostic.config {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false
}
