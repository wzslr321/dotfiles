-- Formatter (format-on-save; toggle with :FormatDisable / :FormatEnable)
return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function(_, opts)
        require("conform").setup(opts)
        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, { desc = "Disable format-on-save (bang = current buffer only)", bang = true })
        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, { desc = "Re-enable format-on-save" })
    end,
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            return { timeout_ms = 500, lsp_format = "fallback" }
        end,
        formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            dart = { "dart_format" },
            dockerfile = { "prettierd", "prettier", stop_after_first = true },
            html = { "prettierd", "prettier", stop_after_first = true },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            json = { "prettierd", "prettier", stop_after_first = true },
            jsonc = { "prettierd", "prettier", stop_after_first = true },
            lua = { "stylua" },
            markdown = { "prettierd", "prettier", stop_after_first = true },
            python = { "ruff_organize_imports", "ruff_format" },
            sh = { "shfmt" },
            rust = { "rustfmt" },
            yaml = { "prettierd", "prettier", stop_after_first = true },
        },
    },
}
