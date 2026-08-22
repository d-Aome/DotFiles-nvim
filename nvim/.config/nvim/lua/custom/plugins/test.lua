-- lua/custom/plugins/init.lua
vim.pack.add {
    gh 'nvim-neotest/nvim-nio',
    gh 'nvim-neotest/neotest',
    gh 'nvim-neotest/neotest-jest',
    gh 'nvim-neotest/neotest-python',
    gh 'fredrikaverpil/neotest-golang',
}

-- lua/configs/neotest.lua
local M = {}

-- The heavy setup function
local function init_neotest()
    -- Early return if already loaded
    if package.loaded['neotest'] then return end

    ---@diagnostic disable-next-line: missing-fields
    require('neotest').setup {
        adapters = {
            require 'rustaceanvim.neotest',
            require 'neotest-python',
            require 'neotest-golang',
            require 'neotest-jest' {
                jestCommand = 'npm test --',
                jestArguments = function(defaultArgs, _) return defaultArgs end,
                jestConfigFile = 'custom.jest.config.ts',
                env = { CI = true },
                cwd = function(_) return vim.fn.getcwd() end,
                isTestFile = require('neotest-jest.jest-util').defaultIsTestFile,
            },
        },
    }
end

-- Define your testing keymaps
M.keys = {
    {
        '<leader>tr',
        function() require('neotest').run.run() end,
        desc = 'Test: Run Nearest',
    },
    {
        '<leader>tf',
        function() require('neotest').run.run(vim.fn.expand '%') end,
        desc = 'Test: Run File',
    },
    {
        '<leader>ts',
        function() require('neotest').summary.toggle() end,
        desc = 'Test: Toggle Summary',
    },
}

for _, map in ipairs(M.keys) do
    local key = map[1]
    local action = map[2]
    local desc = map.desc

    vim.keymap.set('n', key, function()
        init_neotest()
        action()
    end, { desc = desc })
end

return M
