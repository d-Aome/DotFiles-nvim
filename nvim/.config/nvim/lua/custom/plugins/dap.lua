local gh = require('helpers').gh
local M = {}

-- lua/custom/plugins/init.lua
vim.pack.add {
    gh 'mfussenegger/nvim-dap',
    gh 'igorlfs/nvim-dap-view', -- or dap-view
    gh 'williamboman/mason.nvim',
    gh 'jay-babu/mason-nvim-dap.nvim',
    gh 'mfussenegger/nvim-dap-python',
    gh 'leoluz/nvim-dap-go',
}

M.core = function()
    local dap = require 'dap'

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
M.python = function()
    local python_path = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
    require('dap-python').setup(python_path)

    vim.keymap.set(
        'n',
        '<leader>dpr',
        function() require('dap-python').test_method() end,
        { desc = 'Run DAP Python test method' }
    )
end

M.go = function()
    require('dap-go').setup {
        delve = {
            detached = vim.fn.has 'win32' == 0,
        },
    }
end

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

local function load_dap_and_run(action)
    -- 1. Load everything only once
    if not package.loaded['dap'] then
        require 'dap'
        require('dap-view').setup {
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
        } -- your view settings
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

        -- Call your specialized setup functions
        M.core()
        M.python()
        M.go()
        M.javascript()
    end

    -- 2. Execute the requested action
    action()
end

M.keys = {
    -- ========================================== --
    --                 DEBUGGING                  --
    -- ========================================== --
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
    { '<leader>dc', function() require('dap').continue() end, desc = 'Continue' },
    { '<leader>di', function() require('dap').step_into() end, desc = 'Step Into' },
    { '<leader>do', function() require('dap').step_over() end, desc = 'Step Over' },
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    {
        '<leader>B',
        function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
        desc = 'Debug: Set Breakpoint',
    },
    { '<F7>', function() require('dap-view').toggle() end, desc = 'Debug: Toggle DAP View' },
}

-- The heavy loader function
local function init_dap()
    -- Early return if already loaded
    if package.loaded['dap'] then return end

    M.core()
    M.python()
    M.go()
    M.javascript()
end

for _, map in ipairs(M.keys) do
    local key = map[1]
    local action = map[2]
    local desc = map.desc

    vim.keymap.set('n', key, function()
        init_dap()
        action()
    end, { desc = desc })
end

return M
