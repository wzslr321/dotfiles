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
        'stevearc/dressing.nvim',
    },
    {
        'lervag/vimtex',
        lazy = false,
    },
    {
        "L3MON4D3/LuaSnip",
    },
    {
        'nvim-tree/nvim-tree.lua'
    },
    { 'akinsho/toggleterm.nvim', version = "*", opts = {} },
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
    },
    {
        'rcarriga/nvim-dap-ui',
    }
})

require "toggleterm".setup {}
-- require "rust-tools".setup {}
require("luasnip.loaders.from_snipmate").lazy_load()

require "presence".setup({
    -- auto_update = true,
    show_time = true,
    main_image = "file",
    enable_line_number = true,
})
