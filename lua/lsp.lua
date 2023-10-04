-- general 
local capabs = vim.lsp.protocol.make_client_capabilities()
capabs = require('cmp_nvim_lsp').default_capabilities(capabs)
local lspconfig = require 'lspconfig'
vim.diagnostic.config {
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = false
}

require('lspconfig.configs').wingls= ({
  default_config = {
    cmd = { 'wing', 'lsp' },
    filetypes = { 'wing' },
    single_file_support = true,
    root_dir = lspconfig.util.root_pattern("cargo.toml", ".git"),
  },
})

-- lua 
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

-- latex 
lspconfig.digestif.setup{}


-- flutter 
lspconfig.dartls.setup{}

--wing
lspconfig.wingls.setup{}
