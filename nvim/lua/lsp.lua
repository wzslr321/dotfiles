local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require 'lspconfig'

local function with_capabilities(config)
    return vim.tbl_deep_extend('force', {
        capabilities = capabilities,
    }, config or {})
end

-- lua
lspconfig.lua_ls.setup(with_capabilities {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                checkThirdParty = false,
            },
        },
    },
})

-- latex
lspconfig.digestif.setup(with_capabilities())


local clangd_command = {
    'clangd',
    '--query-driver=/opt/homebrew/opt/llvm/bin/clang++'
}

-- cpp
lspconfig.clangd.setup(with_capabilities {
    cmd = clangd_command
})


-- https://github.com/pr2502/ra-multiplex
lspconfig.rust_analyzer.setup(with_capabilities {
    cmd = vim.lsp.rpc.connect("127.0.0.1", 27631),
    init_options = {
        lspMux = {
            version = "1",
            method = "connect",
            server = "rust-analyzer",
        },
    },
})

lspconfig.yamlls.setup(with_capabilities())
