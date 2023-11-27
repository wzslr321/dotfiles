local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		'nvim-treesitter/nvim-treesitter',
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
		'akinsho/flutter-tools.nvim',
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim', -- optional for vim.ui.select
		},
		config = true,
	},
	{
		"L3MON4D3/LuaSnip",
	},
	{
		'nvim-tree/nvim-tree.lua'
	},
	{ 'akinsho/toggleterm.nvim', version = "*", opts = {} },

	{
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{ 
		"carbon-steel/detour.nvim",
	},
	{ 
		'mfussenegger/nvim-dap',
	}
})

require("toggleterm").setup {}
require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "lua", "vim", "vimdoc", "query", "wing" },

	sync_install = false,
	auto_install = true,
	ignore_install = { "javascript" },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	modules = {}
}

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

local dap = require('dap')

dap.adapters.dart = {
  type = 'executable',
  command = 'dart',
  args = {'debug_adapter'}
}

dap.adapters.flutter = {
  type = 'executable',
  command = 'flutter',
  args = {'debug_adapter'}
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
	toolArgs = {"-d", "7029C1E6-5CE5-4A6A-AFF2-80E0AD32D792", "--flavor","development"}
  },
  {
    type = "flutter",
    request = "launch",
    name = "Launch Flutter | Mock",
    dartSdkPath = "/Users/wiktor.zajac/fltuter/bin/dart", 
    flutterSdkPath = "/Users/wiktor.zajac/flutter/bin/flutter",                  
    program = "${workspaceFolder}/lib/main_mock.dart",     
    cwd = "${workspaceFolder}",
	toolArgs = {"-d", "7029C1E6-5CE5-4A6A-AFF2-80E0AD32D792", "--flavor","development"}
  },
  {
    type = "flutter",
    request = "launch",
    name = "Launch Flutter | Production",
    dartSdkPath = "/Users/wiktor.zajac/fltuter/bin/dart", 
    flutterSdkPath = "/Users/wiktor.zajac/flutter/bin/flutter",                  
    program = "${workspaceFolder}/lib/main_prod.dart",     
    cwd = "${workspaceFolder}",
	toolArgs = {"-d", "7029C1E6-5CE5-4A6A-AFF2-80E0AD32D792", "--flavor","production"}
  },
  {
    type = "flutter",
    request = "launch",
    name = "Launch Flutter | Staging",
    dartSdkPath = "/Users/wiktor.zajac/fltuter/bin/dart", 
    flutterSdkPath = "/Users/wiktor.zajac/flutter/bin/flutter",                  
    program = "${workspaceFolder}/lib/main_staging.dart",     
    cwd = "${workspaceFolder}",
	toolArgs = {"-d", "7029C1E6-5CE5-4A6A-AFF2-80E0AD32D792", "--flavor","staging"}
  }
}
