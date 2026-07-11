-- Entry point for Neovim configuration
require("init")
require("plugins")
require("lsp")
require("plugins/nvim-dap")
require("keymappings")

-- Machine-local / private config (lua/private/ is gitignored and may be
-- absent on a fresh clone). Errors inside it should still surface.
local ok, err = pcall(require, "private")
if not ok and not tostring(err):match("module 'private' not found") then
    vim.notify("private config error: " .. tostring(err), vim.log.levels.ERROR)
end
