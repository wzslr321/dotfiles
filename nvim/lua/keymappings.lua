local function map(mode, key, action, options)
    local opts = { noremap = true, silent = true }
    if options then
        opts = vim.tbl_extend("force", opts, options)
    end
    return vim.keymap.set(mode, key, action, opts)
end

-- Format
map("n", "<leader>cf", "<cmd>Fmt<CR>")
map("n", "<leader>df", ":!dart format -l 120 %<CR>")

-- Diagnostics (custom bindings beyond 0.11 defaults)
map("n", "<space>gl", vim.diagnostic.open_float)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    group = vim.api.nvim_create_augroup("UserPythonKeymaps", {}),
    callback = function(ev)
        map("n", "K", function()
            local clients = vim.lsp.get_clients({ bufnr = ev.buf, method = "textDocument/hover" })
            if #clients > 0 then
                vim.lsp.buf.hover()
                return
            end

            vim.notify("No Python LSP hover client attached. Install basedpyright or pyright.", vim.log.levels.WARN)
        end, { buffer = ev.buf, desc = "Python hover docs" })
    end,
})

-- LSP (only non-default bindings; 0.11 provides grn, grr, gra, gri, K, Ctrl-S)
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        map("n", "gD", vim.lsp.buf.declaration, opts)
        map("n", "<space>D", vim.lsp.buf.type_definition, opts)
        map("n", "<space>f", "<cmd>Fmt<CR>", opts)
        if client and client:supports_method("textDocument/hover") then
            map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
        end

        -- inlay hints (inline types & param names) — deterministic LSP info, not AI
        if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
            map("n", "<space>ih", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
            end, opts)
        end
    end,
})

-- Trouble
local trouble = require("trouble")
map("n", "<leader>xa", function()
    trouble.toggle("diagnostics")
end)
map("n", "<leader>xw", function()
    trouble.open("diagnostics")
end)
map("n", "<leader>xd", function()
    trouble.toggle({ mode = "diagnostics", filter = { buf = 0 } })
end)
map("n", "<leader>xq", function()
    trouble.toggle("qflist")
end)
map("n", "<leader>xl", function()
    trouble.toggle("loclist")
end)
map("n", "gr", function()
    trouble.open("lsp_references")
end)

-- Terminal: allow Ctrl-W navigation to leave terminal panes
map("t", "<C-w>h", "<C-\\><C-n><C-w>h")
map("t", "<C-w>l", "<C-\\><C-n><C-w>l")
map("t", "<C-w>j", "<C-\\><C-n><C-w>j")
map("t", "<C-w>k", "<C-\\><C-n><C-w>k")

-- Codex agent
local codex = require("codex_agent")
map("n", "<leader>a?", codex.help, { desc = "Show Codex key help" })
map("v", "<leader>a?", function()
    codex.help(true)
end, { desc = "Show Codex action menu" })
map("n", "<leader>ac", codex.open, { desc = "Open Codex" })
map("n", "<leader>ar", codex.resume, { desc = "Resume last Codex session" })
map("n", "<leader>ab", codex.add_buffer, { desc = "Send buffer path to Codex" })
map("n", "<leader>ad", codex.diff, { desc = "Review Codex/git diff" })
map("n", "<leader>aR", codex.visual_review_off, { desc = "Disable Codex visual review" })
map("n", "<leader>cr", codex.visual_review_refresh, { desc = "Refresh Codex visual review" })
map("n", "<leader>ca", codex.accept_visual_hunk, { desc = "Accept Codex visual hunk" })
map("n", "<leader>cx", codex.reject_visual_hunk, { desc = "Reject Codex visual hunk" })
map("n", "<leader>av", codex.review, { desc = "Codex review" })
map("n", "<leader>aa", codex.apply, { desc = "Apply latest Codex diff" })
map("v", "<leader>as", codex.ask_selection, { desc = "Ask Codex about selection" })

-- Splits
map("n", "<space>rh", ":vertical resize -5<CR>")
map("n", "<space>rl", ":vertical resize +5<CR>")
map("n", "<space>ri", ":resize +5<CR>")
map("n", "<space>rj", ":resize -5<CR>")

-- Detour
map("n", "<leader>dd", ":Detour<cr>")

-- nvim-dap
map("n", "<leader>dbp", ":DapToggleBreakpoint<CR>")
map("n", "<leader>dtr", ":DapToggleRepl<CR>")
map("n", "<leader>dc", ":DapContinue<CR>")

-- dap-ui
local dapui = require("dapui")
map("n", "<leader>dut", function()
    dapui.toggle()
end)
map("n", "<leader>due", function()
    dapui.eval()
end)
---@diagnostic disable-next-line: missing-parameter
map("n", "<leader>duf", function()
    dapui.float_element()
end)
