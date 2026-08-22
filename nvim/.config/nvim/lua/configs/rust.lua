local M = {}

-- Change this to just return the table. Do not set vim.g.rustaceanvim directly here!

M.setup = function()
  local extension_path = require('mason.settings').current.install_root_dir .. '/extensions/'
  local codelldb_path = extension_path .. 'adapter/codelldb'

  ---@type rustaceanvim.Opts
  local config = {
    ---@type rustaceanvim.tools.Opts
    tools = {
      code_actions = {
        ui_select_fallback = true,
      },
      executor = 'termopen',
      test_executor = 'termopen',
    },
    ---@type rustaceanvim.dap.Opts
    dap = {
      adapter = {
        type = 'server',
        port = '${port}',
        executable = {
          command = codelldb_path,
          args = { '--port', '${port}' },
        },
      },
    },
    ---@type rustaceanvim.lsp.ClientOpts
    server = {
      ---@type rustaceanvim.LoadRASettingsOpts
      default_settings = {
        ['rust-analyzer'] = {
          check = {
            command = 'clippy',
            allTargets = false,
          },
          diagnostics = {
            experimental = true,
          },
        },
      },
      -- Note: I moved on_attach INSIDE the server table.
      -- rustaceanvim expects it here, not at the root!
    },
  }
  return config
end

return M
