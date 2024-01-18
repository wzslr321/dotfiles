vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.o.exrc = true;

vim.diagnostic.config {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false
}

vim.g.mapleader = ' ';

vim.api.nvim_create_user_command('Fmt', function() vim.lsp.buf.format() end, { nargs = 0 })
