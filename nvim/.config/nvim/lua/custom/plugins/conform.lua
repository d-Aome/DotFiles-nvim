function gh (repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'stevearc/conform.nvim' }
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

local prettier_ft = {}
for _, ft in ipairs(prettier_filetypes) do
    prettier_ft[ft] = { 'prettier' }
end

require('conform').setup {
    notify_on_error = false,
    default_format_opts = {
        lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
    },
    -- You can also specify external formatters in here.
    formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' },
        c_cpp = { 'clang-format' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        go = { 'goimports', 'gofumpt', 'golines' },
        sh = { 'shfmt' },
        unpack(prettier_ft),
    },
    formatters = {
        ['clang-format'] = {
            prepend_args = {
                '--style={ IndentWidth: 4, \
                TabWidth: 4, \
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
                '--column-width',
                '120',
                '--line-endings',
                'Unix',
                '--indent-type',
                'Spaces',
                '--indent-width',
                '4',
                '--quote-style',
                'ForceSingle',
            },
        },
        ['prettier'] = {
            prepend_args = {
                '--single-quote',
                '--jsx-single-quote',
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
        lsp_fallback = true,
    },
}

vim.keymap.set(
    { 'n', 'v' },
    '<leader>fm',
    function() require('conform').format { async = true } end,
    { desc = '[F]ormat buffer' }
)
