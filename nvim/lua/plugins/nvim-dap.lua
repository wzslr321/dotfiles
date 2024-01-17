local dap = require('dap')

dap.set_log_level('TRACE')

dap.adapters.lldb = {
    type = 'executable',
    command = '/opt/homebrew/bin/lldb-vscode',
    name = 'lldb'
}

dap.configurations.rust = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            local output = ""
            local exit_code = 0
            local on_stdout = function(_, data)
                if data then
                    for _, line in ipairs(data) do
                        output = output .. line
                    end
                end
            end

            local job_id = vim.fn.jobstart('cargo build -Z unstable-options --build-plan', {
                stdout_buffered = true,
                on_stdout = on_stdout,
                on_stderr = on_stdout,
                on_exit = function(id, code, event)
                    exit_code = code
                end,
            })
            vim.fn.jobwait({ job_id })

            if exit_code ~= 0 then
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end

            local build_plan = vim.json.decode(output)
            if not build_plan then
                vim.print(output)
            else
                local links = vim.fn.keys(build_plan.invocations[1].links)[1]
                return links
            end
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
}
