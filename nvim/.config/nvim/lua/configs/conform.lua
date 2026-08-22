local prettier_filetypes = {
  'javascript',
  'json',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'yaml',
  'markdown',
  'vue',
  'css',
  'html',
  'jsonc',
  'graphql',
}

-- Build the formatters_by_ft table cleanly
local formatters_by_ft_table = {
  lua = { 'stylua' },
  python = { 'ruff_format' },
  c_cpp = { 'clang-format' },
  c = { 'clang-format' },
  cpp = { 'clang-format' },
  go = { 'goimports', 'gofumpt', 'golines' },
  sh = { 'shfmt' },
}

-- Safely merge the prettier filetypes into formatters_by_ft
for _, ft in ipairs(prettier_filetypes) do
  formatters_by_ft_table[ft] = { 'prettier' }
end

local options = {
  formatters_by_ft = formatters_by_ft_table,
  formatters = {
    ['clang-format'] = {
      prepend_args = {
        '--style={ \
                IndentWidth: 4, \
                UseTab: Never, \
                ColumnLimit: 120, \
                AccessModifierOffset: 0,\
                IndentAccessModifiers: true, \
                PackConstructorInitializers: Never, \
                SortIncludes: false, \
                AlignArrayOfStructures: None, \
                AlignAfterOpenBracket: BlockIndent, \
                Cpp11BracedListStyle: true, \
                BinPackArguments: true, \
                BinPackParameters: true, \
                DerivePointerAlignment: false,\
                AllowShortFunctionsOnASingleLine: None,\
                PointerAlignment: Left }',
      },
    },
    ['stylua'] = {
      prepend_args = {
        '--line-endings',
        'Unix',
        '--quote-style',
        'ForceSingle',
      },
    },
    ['prettier'] = {
      prepend_args = {
        '--single-qoute',
        '--jsx-single-qoute',
        '--trailing-comma',
        'all',
      },
    },
    ['golines'] = {
      prepend_args = { '--max-len=100' },
    },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = false,
  },
}

require('conform').setup(options)
