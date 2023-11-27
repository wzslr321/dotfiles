vim.g.mapleader = ' ';

-- helpers
vim.api.nvim_create_user_command('Fmt', function() vim.lsp.buf.format() end, { nargs = 0 })


local function map(mode, key, action, options)
    local opts = { noremap = true, silent = true }
    if (options) then
        opts = options
    end
    return vim.api.nvim_set_keymap(mode, key, action, opts)
end

-- Nvim
map('n', '<leader>tt', ':terminal<CR>')


-- NvimTree
map('n', '<leader>e', ':NvimTreeToggle<CR>')

map('n', '<leader>xa', ':TroubleToggle<CR>')
vim.keymap.set("n", "<leader>xx", function() require("trouble").open() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").open("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").open("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").open("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").open("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").open("lsp_references") end)

-- Lsp
map('n', '<leader>ff', ':Fmt<CR>')
vim.keymap.set('n', '<space>gl', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Splits
-- map('n', '<C-h>', ':vertical resize -5<CR>')
-- map('n', '<C-l>', ':vertical resize +5<CR>')
-- map('n', '<C-i>', ':resize +5<CR>')
-- map('n', '<C-j>', ':resize -5<CR>')

-- ToggleTerm
map('n', '<leader>tr', ':ToggleTerm<CR>')

vim.keymap.set('n', '<leader>dd', ":Detour<cr>")

map('n', '<leader>df', ':!dart format -l 120 %<CR>')

-- nvim-dap
local dap = require'dap'

map('n', '<leader>bp', ':DapToggleBreakpoint<CR>')
map('n', '<leader>rt', ':DapToggleRepl<CR>')
map('n', '<leader>co', ':DapContinue<CR>')
