lua <<EOF
local extension_path = '/Users/wiktor/.vscode/extensions/vadimcn.vscode-lldb-1.6.10'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

local opts = {
    dap = {
        adapter = require('rust-tools.dap').get_codelldb_adapter(
            codelldb_path, liblldb_path)
    }
}

-- Normal setup
require('rust-tools').setup(opts)

require('rust-tools.runnables').runnables()
require'rust-tools.hover_actions'.hover_actions()
EOF

nnoremap <silent> hh :<C-u>RustHoverActions<CR>
nnoremap <silent> <leader>rr :RustRunnables<CR>

nnoremap <silent> <leader>dc :call openbrowser#smart_search(expand('<cword>'), "docrust")<CR>
