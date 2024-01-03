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
        }
    }
}

-- latex
lspconfig.digestif.setup {}

-- cpp
lspconfig.clangd.setup {}

-- rust
lspconfig.rust_analyzer.setup {
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = false,
            },
            checkOnSave = {
                allTargets = false,
            }
        },
    }
}
