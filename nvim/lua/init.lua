vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.o.exrc = true

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

vim.g.mapleader = " "
vim.g.maplocalleader = "'"

-- Options (consolidated from init.vim)
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
vim.opt.expandtab = true
vim.opt.laststatus = 3
vim.opt.ruler = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.autoread = true
vim.opt.winborder = "rounded"
vim.opt.pumblend = 10
vim.opt.winblend = 8
vim.opt.fillchars = {
    eob = " ",
    fold = " ",
    foldopen = "▾",
    foldsep = " ",
    foldclose = "▸",
    diff = "╱",
}
vim.opt.wildignore:append("*/node_modules/*,*/.git/*,*/dist/*,*/__pycache__/*")

-- Highlights
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ff9e64", bg = "#292e42", bold = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave", "TermClose" }, {
    group = vim.api.nvim_create_augroup("UserAutoReadChangedFiles", {}),
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("silent! checktime")
        end
    end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave", "TermClose" }, {
    group = vim.api.nvim_create_augroup("CodexVisualReviewRefresh", {}),
    callback = function()
        local ok, codex = pcall(require, "codex_agent")
        if ok then
            codex.visual_review_refresh()
        end
    end,
})

-- Vimtex
vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_compiler_latexmk = {
    options = {
        "-pdf",
        "-shell-escape",
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
    },
}

-- Terminal escape
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Whitespace
vim.g.better_whitespace_enabled = 0

-- Clangd
vim.g.use_clangd = 1

-- Format command
vim.api.nvim_create_user_command("Fmt", function()
    local ok, conform = pcall(require, "conform")
    if ok then
        conform.format({ async = true, lsp_format = "fallback" })
        return
    end
    vim.lsp.buf.format({ async = true })
end, { nargs = 0 })
