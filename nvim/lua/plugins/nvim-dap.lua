local dap = require('dap')

dap.set_log_level('TRACE')

-- Rust
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
                on_exit = function(_, code, _)
                    exit_code = code
                end,
            })
            vim.fn.jobwait({ job_id })

            if exit_code ~= 0 then
                ---@diagnostic disable-next-line: redundant-parameter
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end

            local build_plan = vim.json.decode(output)
            if not build_plan then
                vim.print(output)
            else
                local links = vim.fn.keys(build_plan.invocations[1].links)[1]
                return links
            end
            ---@diagnostic disable-next-line: redundant-parameter
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
}

-- Flutter
dap.adapters.dart = {
    type = 'executable',
    command = 'dart',
    args = { 'debug_adapter' }
}

dap.adapters.flutter = {
    type = 'executable',
    command = 'flutter',
    args = { 'debug_adapter' }
}

dap.set_log_level('TRACE')
dap.configurations.dart = {
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Development",
        dartSdkPath = "/Users/wiktor.zajac/fltuter/bin/dart",
        flutterSdkPath = "/Users/wiktor.zajac/flutter/bin/flutter",
        program = "${workspaceFolder}/lib/main_development.dart",
        cwd = "${workspaceFolder}",
        toolArgs = { "-d", "6C2D48E8-2A78-4F5B-B67C-39A4C50DB24A", "--flavor", "development" }
    },
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Mock",
        dartSdkPath = "/Users/wiktor.zajac/fltuter/bin/dart",
        flutterSdkPath = "/Users/wiktor.zajac/flutter/bin/flutter",
        program = "${workspaceFolder}/lib/main_mock.dart",
        cwd = "${workspaceFolder}",
        toolArgs = { "-d", "7029C1E6-5CE5-4A6A-AFF2-80E0AD32D792", "--flavor", "development" }
    },
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Production",
        dartSdkPath = "/Users/wiktor.zajac/fltuter/bin/dart",
        flutterSdkPath = "/Users/wiktor.zajac/flutter/bin/flutter",
        program = "${workspaceFolder}/lib/main_production.dart",
        cwd = "${workspaceFolder}",
        toolArgs = { "-d", "7029C1E6-5CE5-4A6A-AFF2-80E0AD32D792", "--flavor", "production" }
    },
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Staging",
        dartSdkPath = "/Users/wiktor.zajac/fltuter/bin/dart",
        flutterSdkPath = "/Users/wiktor.zajac/flutter/bin/flutter",
        program = "${workspaceFolder}/lib/main_staging.dart",
        cwd = "${workspaceFolder}",
        toolArgs = { "-d", "70229C1E6-5CE5-4A6A-AFF2-80E0AD32D792", "--flavor", "staging" }
    }
}
