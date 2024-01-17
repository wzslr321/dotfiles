vim.g.mapleader = ' ';

-- helpers
vim.api.nvim_create_user_command('Fmt', function() vim.lsp.buf.format() end, { nargs = 0 })

local function map(mode, key, action, options)
    local opts = { noremap = true, silent = true }
    if (options) then
        opts = options
    end
    return vim.keymap.set(mode, key, action, opts)
end

map('n', '<leader>df', ':!dart format -l 120 %<CR>')

-- Lsp
map('n', '<leader>ff', ':Fmt<CR>')
map('n', '<space>gl', vim.diagnostic.open_float)
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        map('n', 'gD', vim.lsp.buf.declaration, opts)
        map('n', 'gd', vim.lsp.buf.definition, opts)
        map('n', 'K', vim.lsp.buf.hover, opts)
        map('n', 'gi', vim.lsp.buf.implementation, opts)
        map('n', '<space>D', vim.lsp.buf.type_definition, opts)
        map('n', '<space>rn', vim.lsp.buf.rename, opts)
        map({ 'n', 'v' }, '<space>a', vim.lsp.buf.code_action, opts)
        map('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
    end,
})

-- NvimTree
map('n', '<leader>e', ':NvimTreeToggle<CR>')

-- Trouble
local trouble = require 'trouble'
map('n', '<leader>xa', ':TroubleToggle<CR>')
map("n", "<leader>xw", function() trouble.open("workspace_diagnostics") end)
map("n", "<leader>xd", function() trouble.open("document_diagnostics") end)
map("n", "<leader>xq", function() trouble.open("quickfix") end)
map("n", "<leader>xl", function() trouble.open("loclist") end)
map("n", "gr", function() trouble.open("lsp_references") end)


-- Splits
map('n', '<space>rh>', ':vertical resize -5<CR>')
map('n', '<space>rl', ':vertical resize +5<CR>')
map('n', '<space>ri', ':resize +5<CR>')
map('n', '<space>rj', ':resize -5<CR>')

-- ToggleTerm
map('n', '<leader>tr', ':ToggleTerm<CR>')

-- Detour
map('n', '<leader>dd', ":Detour<cr>")

-- nvim-dap
map('n', '<leader>dbp', ':DapToggleBreakpoint<CR>')
map('n', '<leader>dtr', ':DapToggleRepl<CR>')
map('n', '<leader>dc', ':DapContinue<CR>')

--telescope
local telescope = require 'telescope.builtin';
map('n', '<leader>ff', function() telescope.find_files() end)
map('n', '<leader>fg', function() telescope.live_grep() end)
map('n', '<leader>fb', function() telescope.buffers() end)
map('n', '<leader>fh', function() telescope.help_tags() end)


-- dap-ui
local dapui = require 'dapui';
map('n', '<leader>dut', function() dapui.toggle() end)
map('n', '<leader>due', function() dapui.eval() end)
map('n', '<leader>duf', function() dapui.float_element() end)
