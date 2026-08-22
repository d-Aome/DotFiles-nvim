local M = {}

-- ========================================== --
-- 1. Core Engine & C/Rust Setup
-- ========================================== --
M.core = function()
    local dap = require 'dap'
    local dap_view = require 'dap-view'
    -- Mason Setup
    require('mason-nvim-dap').setup {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
            'delve',
            'debugpy',
            'codelldb',
            'js-debug-adapter',
        },
    }

    -- DAP View Setup
    dap_view.setup {
        windows = {
            size = 0.25,
            position = 'below',
            terminal = {
                size = 0.5,
                position = 'right',
                hide = {},
            },
        },
        auto_toggle = true,
        winbar = {
            controls = {
                enabled = true,
            },
        },
    }

    -- C++ / C / RUST
    dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
            command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
            args = { '--port', '${port}' },
        },
    }

    local cpp_config = {
        {
            name = 'Launch file',
            type = 'codelldb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
        },
    }

    dap.configurations.cpp = cpp_config
    dap.configurations.c = cpp_config
    dap.configurations.rust = cpp_config
end

-- ========================================== --
-- 2. Python Setup
-- ========================================== --
M.python = function()
    local python_path = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
    require('dap-python').setup(python_path)

    vim.keymap.set('n', '<leader>dpr', function()
        require('dap-python').test_method()
    end, { desc = 'Run DAP Python test method' })
end

-- ========================================== --
-- 3. Go Setup
-- ========================================== --
M.go = function()
    require('dap-go').setup {
        delve = {
            detached = vim.fn.has 'win32' == 0,
        },
    }
end

-- ========================================== --
-- 4. JavaScript / TypeScript Setup
-- ========================================== --
M.javascript = function()
    local dap = require 'dap'

    dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
            command = 'node',
            args = {
                os.getenv 'HOME' .. '/vscode-js-debug/out/src/vsDebugServer.js',
                '${port}',
            },
        },
    }
    dap.adapters['node-terminal'] = dap.adapters['pwa-node']

    local js_based_languages = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }
    for _, language in ipairs(js_based_languages) do
        local configs = {
            {
                name = 'Local: Next.js: launch and debug',
                type = 'pwa-node',
                request = 'launch',
                program = '${workspaceFolder}/node_modules/next/dist/bin/next',
                args = { 'dev' },
                cwd = '${workspaceFolder}',
                console = 'integratedTerminal',
                skipFiles = { '<node_internals>/**', 'node_modules/**' },
                runtimeArgs = { '--inspect' },
            },
            {
                type = 'pwa-node',
                request = 'launch',
                name = 'Local: Launch file (Normal Node)',
                program = '${file}',
                cwd = '${workspaceFolder}',
                stopOnEntry = true,
                console = 'integratedTerminal',
            },
            {
                type = 'pwa-node',
                request = 'attach',
                name = 'Local: Attach to Node process',
                processId = require('dap.utils').pick_process,
                cwd = vim.fn.getcwd(),
            },
        }

        if language == 'typescript' or language == 'typescriptreact' then
            table.insert(configs, 1, {
                type = 'pwa-node',
                request = 'launch',
                name = 'Local: Launch Current File (ts-node)',
                program = '${file}',
                cwd = '${workspaceFolder}',
                runtimeArgs = { '--loader', 'ts-node/esm' },
                sourceMaps = true,
                stopOnEntry = true,
                console = 'integratedTerminal',
            })
        end

        dap.configurations[language] = configs
    end
end

M.keys = {
    -- ========================================== --
    --                 DEBUGGING                  --
    -- ========================================== --
    {
        '<leader>db',
        function()
            require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle Breakpoint',
    },
    {
        '<leader>dc',
        function()
            require('dap').continue()
        end,
        desc = 'Continue',
    },
    {
        '<leader>di',
        function()
            require('dap').step_into()
        end,
        desc = 'Step Into',
    },
    {
        '<leader>do',
        function()
            require('dap').step_over()
        end,
        desc = 'Step Over',
    },
    {
        '<F5>',
        function()
            require('dap').continue()
        end,
        desc = 'Debug: Start/Continue',
    },
    {
        '<F1>',
        function()
            require('dap').step_into()
        end,
        desc = 'Debug: Step Into',
    },
    {
        '<F2>',
        function()
            require('dap').step_over()
        end,
        desc = 'Debug: Step Over',
    },
    {
        '<F3>',
        function()
            require('dap').step_out()
        end,
        desc = 'Debug: Step Out',
    },
    {
        '<leader>b',
        function()
            require('dap').toggle_breakpoint()
        end,
        desc = 'Debug: Toggle Breakpoint',
    },
    {
        '<leader>B',
        function()
            require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
    },
    {
        '<F7>',
        function()
            require('dap-view').toggle()
        end,
        desc = 'Debug: Toggle DAP View',
    },
}
-- ========================================================================== --
--                                 DEBUGGING                                  --
-- ========================================================================== --

return M
