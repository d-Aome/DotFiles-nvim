local gh = require('helpers').gh
local on_attach = require('helpers').on_attach

vim.pack.add { gh 'j-hui/fidget.nvim' }
require('fidget').setup {}

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
--
-- Enable the following language servers
---@type table<string, vim.lsp.Config>
local servers = {
    asm_lsp = {
        filetypes = { 'asm', 's', 'S' },
        root_dir = function(fname) return vim.fs.root(fname, '.git') or vim.uv.os_homedir() end,
        on_attach = on_attach,
    },
    html = {
        filetypes = { 'html', 'templ' },
        on_attach = on_attach,
    },
    cssls = {
        filetypes = {
            'css',
            'scss',
            'less',
        },
        on_attach = on_attach,
    },
    ruff = {
        filetypes = {
            'python',
        },
        on_attach = on_attach,
    },
    bashls = {
        filetypes = {
            'sh',
            'bash',
        },
        on_attach = on_attach,
    },
    zls = {
        filetypes = {
            'zig',
            'zir',
        },
        on_attach = on_attach,
    },
    neocmake = {
        on_attach = on_attach,
        filetypes = {
            'cmake',
        },
        settings = {
            format = {
                enable = true,
            },
            lint = {
                enable = true,
            },
            scan_cmake_in_package = true,
        },
    },
    jedi_language_server = {
        init_options = {
            markupKindPreffered = 'markdown',
        },
        filetypes = {
            'python',
        },
    },
    glsl_analyzer = {
        filetypes = { 'glsl', 'vert', 'frag', 'geom', 'tesc', 'tese', 'comp' },
    },
    ts_ls = {
        on_attach = on_attach,
        filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
        },
        settings = {
            javascript = { preferences = { quoteStyle = 'single' } },
            typescript = { preferences = { quoteStyle = 'single' } },
        },
    },
    gopls = {
        on_attach = on_attach,
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gotmpl', 'gowork' },
        root_dir = function(fname)
            local util = require 'lspconfig.util'
            return util.root_pattern('.git', 'compile_commands.json')(fname)
        end,
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                completeUnimported = true,
                usePlaceholders = true,
                staticcheck = true,
            },
        },
    },
    clangd = {
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        single_file_support = true,
        on_attach = on_attach,
    },
    -- stylua removed from here: it goes in Mason tools below

    lua_ls = {
        on_attach = on_attach,
        on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath 'config'
                    and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
                workspace = {
                    checkThirdParty = false,
                    library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                        '${3rd}/luv/library',
                        '${3rd}/busted/library',
                    }),
                },
            })
        end,
        settings = {
            Lua = { format = { enable = false } },
        },
    },
}

-- Packages
vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim', -- Restored to translate names
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
    gh 'nvimdev/lspsaga.nvim',
}

require('mason').setup {}

-- Use a flat lookup table for O(1) checks
local ignore_install = {
    rust_analyzer = true,
    asm_lsp = true,
    racket_langserver = true,
}

-- 1. Build the list of LSP servers to install
local lsp_to_install = {}
for server_name, _ in pairs(servers) do
    if not ignore_install[server_name] then table.insert(lsp_to_install, server_name) end
end

-- 2. Let mason-lspconfig handle LSPs (It knows html = html-lsp)
require('mason-lspconfig').setup {
    ensure_installed = lsp_to_install,
    automatic_installation = false,
}

-- 3. Let mason-tool-installer handle formatters and linters
require('mason-tool-installer').setup {
    ensure_installed = {
        'stylua',
        'markdownlint',
        'luacheck',
        'ruff',
        'mypy',
        'eslint_d',
        'shellcheck',
        'prettier',
        'clang-format',
        'goimports',
        'gofumpt',
        'golines',
        'shfmt',
    },
}

local saga_ok, saga = pcall(require, 'lspsaga')
if saga_ok then
    saga.setup {
        ui = {
            border = 'double',
            code_action = '💡',
        },
        rename = {
            quit = '<ESC>',
        },
        -- 2. Code Action menu
        code_action = {
            keys = {
                quit = '<ESC>', -- Overrides the default 'q' to exit
                exec = '<CR>',
            },
        },
        -- 3. Hover module (usually closes with 'q' or moving the cursor)
        hover = {
            max_width = 0.8,
        },
        -- 4. Finder module (if you decide to use it later)
        finder = {
            keys = {
                quit = { 'q', '<ESC>' }, -- Allows both 'q' and <ESC> to exit
            },
        },
    }
end

-- 4. Start servers natively
local function start_server(name, config)
    if ignore_install[name] then return end

    config.capabilities = vim.tbl_deep_extend('force', config.capabilities or {}, {})
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
end

-- Registration loop
for name, config in pairs(servers) do
    start_server(name, config)
end
