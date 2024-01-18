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

local dart_path = os.getenv("DART_PATH");
local flutter_path = os.getenv("FLUTTER_PATH");

local get_device = function()
    local co = coroutine.running()
    local output = ""
    local exit_code = 0
    local on_stdout = function(_, data)
        if data then
            for _, line in ipairs(data) do
                if string.match(line, '•') then
                    output = output .. line .. '\n'
                end
            end
        end
    end

    vim.print("Running flutter devices...")
    local job_id = vim.fn.jobstart('flutter devices', {
        stdout_buffered = true,
        on_stdout = on_stdout,
        on_stderr = on_stdout,
        on_exit = function(_, code, _)
            exit_code = code
        end,
    })
    vim.fn.jobwait({ job_id })
    if exit_code ~= 0 then
        return vim.print("Failed to retrieve device")
    end

    vim.ui.select(vim.fn.split(output, '\n'), {
        prompt = "Select Device",
        telescope = require 'telescope.themes'.get_cursor(),
    }, function(selected)
        coroutine.resume(co, selected)
    end
    );
    local selected_device = coroutine.yield()
    return vim.fn.trim(vim.fn.split(selected_device, '•')[2])
end

dap.configurations.dart = {
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Development",
        dartSdkPath = dart_path,
        flutterSdkPath = flutter_path,
        program = "${workspaceFolder}/lib/main_development.dart",
        cwd = "${workspaceFolder}",
        toolArgs = function()
            local default_flutter_device = os.getenv("DEFAULT_FLUTTER_DEVICE");
            local selected_device = default_flutter_device;
            if not selected_device then
                selected_device = get_device();
            end

            return { "-d", selected_device, "--flavor", "development" };
        end
    },
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Mock",
        dartSdkPath = dart_path,
        flutterSdkPath = flutter_path,
        program = "${workspaceFolder}/lib/main_mock.dart",
        cwd = "${workspaceFolder}",
        toolArgs = function()
            local default_flutter_device = os.getenv("DEFAULT_FLUTTER_DEVICE");
            local selected_device = default_flutter_device;
            if not selected_device then
                selected_device = get_device();
            end

            return { "-d", selected_device, "--flavor", "development" };
        end
    },
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Production",
        dartSdkPath = dart_path,
        flutterSdkPath = flutter_path,
        program = "${workspaceFolder}/lib/main_production.dart",
        cwd = "${workspaceFolder}",
        toolArgs = function()
            local default_flutter_device = os.getenv("DEFAULT_FLUTTER_DEVICE");
            local selected_device = default_flutter_device;
            if not selected_device then
                selected_device = get_device();
            end

            return { "-d", selected_device, "--flavor", "development" };
        end
    },
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter | Staging",
        dartSdkPath = dart_path,
        flutterSdkPath = flutter_path,
        program = "${workspaceFolder}/lib/main_staging.dart",
        cwd = "${workspaceFolder}",
        toolArgs = function()
            local default_flutter_device = os.getenv("DEFAULT_FLUTTER_DEVICE");
            local selected_device = default_flutter_device;
            if not selected_device then
                selected_device = get_device();
            end

            return { "-d", selected_device, "--flavor", "development" };
        end
    }
}
