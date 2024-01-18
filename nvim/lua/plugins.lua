local plugins_list = require 'plugins.plugins_list';

-- Setup Lazy | Package Manager |
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

local lazy = require 'lazy';

lazy.setup(plugins_list)

-- Plugin setups
require "toggleterm".setup {}
require "luasnip.loaders.from_snipmate".lazy_load()
require "dapui".setup()
require "flutter-tools".setup {
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
require "neodev".setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
})

require("dressing").setup()
