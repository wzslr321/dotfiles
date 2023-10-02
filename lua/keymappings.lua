vim.api.nvim_create_user_command('Fmt', function() vim.lsp.buf.format() end, { nargs = 0 })

vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap=true, silent=true} )
