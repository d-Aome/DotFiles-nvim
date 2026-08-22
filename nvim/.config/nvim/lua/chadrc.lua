---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = 'horizon',
  transparency = true,
  hl_add = {},
  hl_override = {
    LspInlayHint = {
      bg = 'NONE',
    },
    Comment = { italic = true },
    ['@comment'] = { italic = true },
    NormalFloat = { bg = 'black' },
    EndOfBuffer = { bg = 'NONE' }, -- The tildes (~) at the end of the file
    Folded = { bg = 'NONE' }, -- Folded code blocks        FloatBorder = {
    BlinkCmpMenu = { bg = 'black', fg = 'white' },
    BlinkCmpMenuBorder = {
      bg = 'black',
    },
  },
}

M.colorify = {
  enabled = true,
  mode = 'virtual',
}

M.nvdash = { load_on_startup = true }
M.ui = {
  tabufline = {
    enabled = false,
  },
  telescope = {
    style = 'borderless',
  },
  cmp = {
    style = 'default',
    icons_left = true,
    icons = true,
    format_colors = {
      lsp = true,
      icon = 'icons_left',
    },
  },
  statusline = {
    separator_style = 'default',
    modules = {
      macro = function()
        local recording_register = vim.fn.reg_recording()
        if recording_register == '' then
          return ''
        else
          -- Using %#{HighlightGroup}# syntax for colors.
          -- "St_LspError" usually gives a nice red color suitable for recording.
          return '%#St_LspError# 󰑋 Rec @' .. recording_register .. ' %#StText#'
        end
      end,
    },
    theme = 'vscode_colored',
    order = {
      'mode',
      'file',
      'git',
      'macro',
      '%=',
      'lsp_msg',
      '%=',
      'diagnostics',
      'lsp',
      'cursor',
      'cwd',
    },
  },
}

M.lsp = {
  signature = false,
}

return M
