local on_attach = require('nvchad.configs.lspconfig').on_attach
local on_init = function(_, _bufnr) end
local capabilities = require('nvchad.configs.lspconfig').capabilities

-- local lspconfig = require("lspconfig") -- pre nvim 0.11
local lspconfig = require 'nvchad.configs.lspconfig' -- nvim 0.11

capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { 'markdown', 'plaintext' },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  },
}

-- list of all servers configured.
lspconfig.servers = {
  'lua_ls',
  'neocmake',
  'clangd',
  'vue_ls',
  'asm_lsp',
  'jedi_language_server',
  'racket_langserver',
  'arduino_language_server',
}

-- list of servers configured with default config.
local default_servers = {
  'html',
  'cssls',
  'ruff',
  'gopls',
  'bashls',
  'zls',
  'glsl_analyzer',
}

-- lsps with default config
for _, lsp in ipairs(default_servers) do
  -- lspconfig[lsp].setup({ -- pre nvim 0.11
  vim.lsp.config(lsp, { -- nvim 0.11
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  })
end

-- typescript, javascript, react

vim.lsp.config('volar', {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})

-- C/C++
vim.lsp.config('clangd', { -- nvim 0.11
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  cmd = {
    'clangd',
    '--fallback-style=-std=c23',
    '--clang-tidy',
  },
  on_init = on_init,
  capabilities = capabilities,
})

-- Golang
-- vim.lsp.config('gopls', { -- nvim 0.11
--   on_attach = function(client, bufnr)
--     client.server_capabilities.documentFormattingProvider = false
--     client.server_capabilities.documentRangeFormattingProvider = false
--     on_attach(client, bufnr)
--   end,
--   on_init = on_init,
--   capabilities = capabilities,
--   cmd = { 'gopls' },
--   filetypes = { 'go', 'gomod', 'gowork' },
--   -- root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"), -- pre nvim 0.11
--   root_dir = require('lspconfig.util').root_pattern('go.work', 'go.mod', '.git'), -- nvim 0.11
--   settings = {
--     gopls = {
--       analyses = {
--         unusedparams = true,
--       },
--       completeUnimported = true,
--       usePlaceholders = true,
--       staticcheck = true,
--     },
--   },
-- })

-- lspconfig.lua_ls.setup({ -- pre nvim 0.11
vim.lsp.config('lua_ls', { -- nvim 0.11
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,

  settings = {
    Lua = {
      workspace = {
        library = {
          vim.fn.expand '$VIMRUNTIME/lua',
          vim.fn.expand '$VIMRUNTIME/lua/vim/lsp',
          vim.fn.stdpath 'data' .. '/lazy/ui/nvchad_types',
          vim.fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy',
          '${3rd}/love2d/library',
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})
-- asm lsp
vim.lsp.config('asm_lsp', {
  filetypes = { 'asm', 's', 'S' },
  root_dir = function(fname) return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir() end,
})
-- Neocmake with formatting enabled
vim.lsp.config('neocmake', {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,

  init_options = {
    format = { enable = true },
    lint = { enable = true },
    scan_cmake_in_package = true,
  },
})

-- Jedi lsp servers
vim.lsp.config('jedi_language_server', {
  on_attach = on_attach,
  init_options = {
    markupKindPrefered = 'markdown',
  },
  capabilities = capabilities,
})

vim.lsp.config('racket_langserver', {
  cmd = { 'racket', '--lib', 'racket-langserver' },
  filetypes = { 'racket', 'scheme' },
  single_file_support = true,
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  diagnostics = {
    underline = {
      enabled = false,
    },
  },
})

vim.lsp.enable 'racket_langserver'

vim.lsp.config('arduino_language_server', {
  cmd = {
    'arduino-language-server',
    '-clangd',
    '/usr/bin/clangd',
    '-cli-config',
    vim.fn.expand '~/.arduino15/arduino-cli.yaml',
    '-fqbn',
    'arduino:esp32:nano_nora',
  },
  capabilities = {
    textDocument = {
      semantic_tokens = vim.NIL,
    },
    workspace = {
      semantic_Tokens = vim.NIL,
    },
  },
  on_attach = on_attach,
  on_init = on_init,
})
