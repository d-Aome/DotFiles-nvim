local gh = require('helpers').gh
-- lua/custom/plugins/init.lua
vim.pack.add {
    gh 'mrcjkb/rustaceanvim',
}

-- lua/configs/rust.lua
local M = {}

M.setup = function()
    local extension_path = require('mason.settings').current.install_root_dir .. '/extensions/'
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

    local on_attach = require('helpers').on_attach

    local config = {
        ---@type rustaceanvim.tools.Config
        tools = {
            code_action = {
                ui_select_fallback = true,
            },
            float_win_config = {
                border = 'double',
            },
            executor = 'termopen',
            test_executor = 'termopen',
        },
        ---@type rustaceanvim.dap.Opts
        dap = {
            dap = {
                adapter = {
                    type = 'server',
                    port = '${port}',
                    executable = {
                        command = codelldb_path,
                        args = { '--port', '${port}', '--liblldb', liblldb_path },
                    },
                },
            },
        },
        ---@type rustaceanvim.lsp.ClientOpts
        server = {
            ---@type rustaceanvim.LoadRASettingsOpts
            default_settings = {
                ['rust-analyzer'] = {
                    checkOnSave = { command = 'clippy', enable = true },
                    check = { command = 'clippy', allTargets = false },
                    diagnostics = {
                        cargo = {
                            allFeatures = true,
                        },
                    },
                    on_attach = on_attach,
                },
            },
        },
    }
    return config
end

return M
