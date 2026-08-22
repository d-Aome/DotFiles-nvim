local M = {}
M.noice_opts = {
  notify = { enabled = true },
  views = {
    cmdline_popup = {
      position = {
        row = '40%', -- Adjust this percentage to move it up or down
        col = '50%',
      },
      size = {
        width = 60,
        height = 'auto',
      },
    },
  },
  popupmenu = {
    relative = 'editor',
    position = {
      row = '53%', -- Positions the suggestion menu just below the centered cmdline
      col = '50%',
    },
  },
  lsp = {
    enabled = false,
    hover = {
      enabled = true,
    },
    signature = {
      enabled = false,
      opts = {
        focus = false,
      },
    },
    auto_open = {
      enabled = false,
    },
  },
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
  },
  cmdline = {
    command_palette = false,
  },
}

M.notify_config = function()
  require('notify').setup {
    background_colour = '#000000',

    -- local buf = an integer
    -- local notification = a table with the notify.Record format
    highlights = {
      title = 'NotifyTitle',
      icon = 'NotifyIcon',
      border = 'NotifyBorder',
      body = 'NotifyBody',
    },
    merge_duplicates = true,
    routes = {
      filter = {
        event = 'lsp',
        kind = 'code_action',
      },
      opts = {
        skip = true,
      },
    },
  }
end

return M
