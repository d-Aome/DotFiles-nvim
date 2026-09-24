local M = {}
local overseer_opts = {
  new_task_opts = {},
  on_new_task = function(task) require('overseer').open { enter = false, direction = 'bottom' } end, -- a function that gets overseer.Task when it is created, before calling `task:start`
}
M.get_opts = function()
  local osys = require 'cmake-tools.osys'
  return {
    cmake_command = 'cmake', -- this is used to specify cmake command path
    ctest_command = 'ctest', -- this is used to specify ctest command path
    cmake_use_preset = true,
    cmake_regenerate_on_save = true, -- auto generate when save CMakeLists.txt
    cmake_generate_options = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=1' }, -- this will be passed when invoke `CMakeGenerate`
    cmake_build_options = {}, -- this will be passed when invoke `CMakeBuild`
    -- support macro expansion:
    --       ${kit}
    --       ${kitGenerator}
    --       ${variant:xx}
    cmake_build_directory = function()
      if osys.iswin32 then return 'build\\${variant:buildType}' end
      return 'build/${variant:buildType}'
    end, -- this is used to specify generate directory for cmake, allows macro expansion, can be a string or a function returning the string, relative to cwd.
    cmake_compile_commands_options = {
      action = 'soft_link', -- available options: soft_link, copy, lsp, none
      -- soft_link: this will automatically make a soft link from compile commands file to target
      -- copy:      this will automatically copy compile commands file to target
      -- lsp:       this will automatically set compile commands file location using lsp
      -- none:      this will make this option ignored
      target = vim.loop.cwd(), -- path to directory, this is used only if action == "soft_link" or action == "copy"
    },
    cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
    cmake_variants_message = {
      short = { show = true }, -- whether to show short message
      long = { show = true, max_length = 40 }, -- whether to show long message
    },
    cmake_dap_configuration = { -- debug settings for cmake
      name = 'cpp',
      type = 'codelldb',
      request = 'launch',
      stopOnEntry = false,
      runInTerminal = true,
      console = 'integratedTerminal',
    },
    cmake_executor = { -- executor to use
      name = 'overseer', -- name of the executor
      opts = overseer_opts,
    },
    cmake_runner = { -- runner to use
      name = 'overseer', -- name of the runner
      opts = overseer_opts, -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
    },
    cmake_notifications = {
      runner = { enabled = true },
      executor = { enabled = true },
      spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }, -- icons used for progress display
      refresh_rate_ms = 100, -- how often to iterate icons
    },
    cmake_virtual_text_support = true, -- Show the target related to current file using virtual text (at right corner)
    cmake_use_scratch_buffer = false, -- A buffer that shows what cmake-tools has done
  }
end

return M
