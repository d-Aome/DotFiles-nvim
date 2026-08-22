local lint = require 'lint'

lint.linters_by_ft = {
  lua = { 'luacheck' },
  python = { 'ruff', 'mypy' },
  javascript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescript = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  vue = { 'eslint_d' },
  sh = { 'shellcheck' },
}

-- ========================================== --
-- 1. Lua Setup
-- ========================================== --
local luacheck = lint.linters.luacheck

luacheck.args = {
  '--globals',
  'love',
  'vim',
}
-- ========================================== --
-- 2. Python Setup
-- ========================================== --

local mypy = lint.linters.mypy
local original_mypy_args = vim.deepcopy(mypy.args)

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
  callback = function()
    local virtual = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX' or '/usr'
    local python_executable = virtual .. '/bin/python3'

    mypy.args = vim.deepcopy(original_mypy_args)
    table.insert(mypy.args, '--python-executable')
    table.insert(mypy.args, python_executable)

    require('lint').try_lint()
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  callback = function()
    lint.try_lint()
  end,
})
