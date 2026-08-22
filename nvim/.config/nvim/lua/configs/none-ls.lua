local M = {}

-- ========================================== --
-- 1. Core Engine Setup (Starts Empty)
-- ========================================== --
M.core = function()
    local null_ls = require 'null-ls'
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

    require('mason-null-ls').setup {
        ensure_installed = {
            -- Formatters
            'clang-format',
            'gofumpt',
            'golines',
            'prettier',
            'stylua',
            'goimports',
            'prettier',
            -- Linters
            'luacheck',
            'shellcheck',
            'eslint_d',
            'ruff',
            'mypy',
        },
        automatic_installation = true,
    }

    null_ls.setup {
        methods = {
            null_ls.methods.DIAGNOSTICS,
            null_ls.methods.DIAGNOSTICS_ON_SAVE,
            null_ls.methods.DIAGNOSTICS_ON_OPEN,
        },
        sources = {},
        root_dir = require('null-ls.utils').root_pattern('.null-ls-root', 'Makefile', '.git'),
        diagnostics_format = '',
        on_attach = function(client, bufnr)
            if client:supports_method 'textDocument/formatting' then
                vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format { async = false }
                    end,
                })
            end
        end,
    }
end

-- ========================================== --
-- 7. Shell Setup
-- ========================================== --
M.sh = function()
    local null_ls = require 'null-ls'
    null_ls.register {
        require 'none-ls-shellcheck.code_actions',
        require('none-ls-shellcheck.diagnostics').with {
            filetypes = { 'sh' },
        },
    }
end

return M
