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

vim.api.nvim_create_user_command('Fmt', function()
    local ok, conform = pcall(require, 'conform')
    if ok then
        conform.format({ async = true, lsp_format = "fallback" })
        return
    end

    vim.lsp.buf.format({ async = true })
end, { nargs = 0 })
