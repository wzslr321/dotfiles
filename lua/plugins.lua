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
		"L3MON4D3/LuaSnip",
	},
	{
		'nvim-tree/nvim-tree.lua'
	},
})
