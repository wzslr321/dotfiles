local function setup_lsp(server, opts)
    opts = opts or {}

    if vim.lsp.config and vim.lsp.enable then
        vim.lsp.config(server, opts)
        vim.lsp.enable(server)
        return
    end

    require("lspconfig")[server].setup(opts)
end

local function setup_if_executable(server, executable, opts)
    if vim.fn.executable(executable) == 1 then
        setup_lsp(server, opts)
        return true
    end

    return false
end

-- lua
setup_lsp("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
            },
        },
    },
})

-- latex
setup_lsp("digestif")

-- cpp
setup_lsp("clangd", {
    cmd = {
        "clangd",
        "--query-driver=/opt/homebrew/opt/llvm/bin/clang++",
    },
})

-- shell / docker
setup_if_executable("bashls", "bash-language-server")
setup_if_executable("dockerls", "docker-langserver")

-- python
setup_if_executable("ruff", "ruff")

local has_python_type_lsp = setup_if_executable("basedpyright", "basedpyright-langserver", {
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
            },
        },
    },
}) or setup_if_executable("pyright", "pyright-langserver", {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
            },
        },
    },
})

if not has_python_type_lsp then
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        group = vim.api.nvim_create_augroup("PythonLspMissingTypeServer", {}),
        once = true,
        callback = function()
            vim.notify(
                "Install basedpyright or pyright for Python hover, go-to-definition, and type checking.",
                vim.log.levels.WARN
            )
        end,
    })
end

-- rust
local rust_analyzer_settings = {
    ["rust-analyzer"] = {
        -- richer lints on save (clippy instead of plain check)
        check = { command = "clippy" },
        cargo = { buildScripts = { enable = true } },
        procMacro = { enable = true },
        completion = {
            -- completing a call fills placeholder args you Tab through
            callable = { snippets = "fill_arguments" },
        },
    },
}

-- Prefer ra-multiplex (one shared rust-analyzer across all nvim instances on a
-- project) when its binary is installed; otherwise fall back to a plain
-- rust-analyzer so Rust LSP works out of the box.
if vim.fn.executable("ra-multiplex") == 1 then
    setup_lsp("rust_analyzer", {
        cmd = vim.lsp.rpc.connect("127.0.0.1", 27631),
        init_options = {
            lspMux = {
                version = "1",
                method = "connect",
                server = "rust-analyzer",
            },
        },
        settings = rust_analyzer_settings,
    })
else
    setup_lsp("rust_analyzer", {
        settings = rust_analyzer_settings,
    })
end

-- yaml (extra project-specific schemas can be merged in from lua/private/)
setup_if_executable("yamlls", "yaml-language-server", {
    settings = {
        yaml = {
            schemaStore = {
                enable = true,
            },
            validate = true,
            completion = true,
            hover = true,
        },
    },
})
