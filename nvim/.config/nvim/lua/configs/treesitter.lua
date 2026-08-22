local M = {}

M.opts = {
  ensure_installed = {
    -- Base & Shell
    'bash',
    'make',
    'cmake',
    'toml',
    'yaml',
    'printf',
    'diff',

    -- C / C++ / Rust
    'c',
    'cpp',
    'rust',

    -- Go
    'go',
    'gomod',
    'gosum',
    'gotmpl',
    'gowork',

    -- Web & Docs
    'html',
    'markdown',
    'markdown_inline',
    'query',
    'javascript',
    'tsx',
    'typescript',

    -- Neovim / Lua
    'lua',
    'luadoc',
    'vim',
    'vimdoc',

    -- others
    'python',
    'regex',
    'java',
  },
  auto_install = true,
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = { enable = true },
  textobjexts = {
    select = {
      enable = false,
    },
  },
}

M.setup = function(_, opts)
  require('nvim-treesitter.config').setup(opts)
end

return M
