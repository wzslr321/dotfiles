-- general configs
local capabs = vim.lsp.protocol.make_client_capabilities()
capabs = require('cmp_nvim_lsp').default_capabilities(capabs)
local lspconfig = require 'lspconfig'
vim.diagnostic.config {
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = false
}

-- lua lsp
lspconfig.lua_ls.setup {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

-- latex lsp
lspconfig.digestif.setup{}
