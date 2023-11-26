local dap = require('dap')

dap.adapters.codelldb = {
  type = 'executable',
  command = '/opt/homebrew/bin/lldb-vscode',
  name = 'lldb'
}

dap.configurations.rust= {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}
