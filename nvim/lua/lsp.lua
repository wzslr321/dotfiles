local capabs = vim.lsp.protocol.make_client_capabilities()
capabs = require('cmp_nvim_lsp').default_capabilities(capabs)

local lspconfig = require 'lspconfig'

-- lua
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
        },
    },
}

-- latex
lspconfig.digestif.setup {}


-- cpp
lspconfig.clangd.setup {
    cmd = { "/opt/homebrew/Cellar/llvm/19.1.7/bin/clangd"},
  root_dir = function()
    return vim.fn.getcwd() -- or specify a specific path
  end
}

-- https://github.com/pr2502/ra-multiplex
lspconfig.rust_analyzer.setup {
    cmd = vim.lsp.rpc.connect("127.0.0.1", 27631),
    init_options = {
        lspMux = {
            version = "1",
            method = "connect",
            server = "rust-analyzer",
        },
    },
}

lspconfig.yamlls.setup {}
