lua require('plugins')
lua require('lsp')
lua require('plugins/nvim-cmp')
lua require('plugins/nvim-tree')
lua require('keymappings')
lua require('init')

filetype plugin indent on

syntax enable

set tabstop=4
set shiftwidth=4
set softtabstop=-1
set nu rnu

colorscheme tokyonight-night

let maplocalleader = ","
