-- Configurable status line
-- local airline = { 'vim-airline/vim-airline' };
local galaxyline = { 'glepnir/galaxyline.nvim' };

-- The best theme there is.
-- local tokyodark_theme = {
--     "tiagovla/tokyodark.nvim",
--     opts = {},
--     config = function(_, opts)
--         require("tokyodark").setup(opts)
--         vim.cmd [[colorscheme tokyodark]]
--     end,
-- };

local nightfox_theme = {
    'EdenEast/nightfox.nvim',
    config = function(_, opts)
        require("nightfox").setup(opts)
        vim.cmd [[colorscheme nightfox]]
    end,
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

local markdown_preview = {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
};

-- Helper for plugin writing
local neodev = { 'folke/neodev.nvim' };

-- UI helper
local dressing = {
    'stevearc/dressing.nvim',
    opts = {},
};

local indent_line = {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}
}

local treesiter = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
}
local treesiter_context = {
    'nvim-treesitter/nvim-treesitter-context'
}

local barbar = {
    'romgrk/barbar.nvim',
    dependencies = {
        'lewis6991/gitsigns.nvim',
    },
    init = function() vim.g.barbar_auto_setup = false end,
}


return {
    --airline,
    -- tokyodark_theme,
    galaxyline,
    nightfox_theme,
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
    markdown_preview,
    neodev,
    dressing,
    treesiter,
    indent_line,
    treesiter_context,
    barbar,
}
