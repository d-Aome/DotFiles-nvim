local autocmd = vim.api.nvim_create_autocmd

-- user event that loads after UIEnter + only if file buf is there
autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('NvFilePost', { clear = true }),
  callback = function(args)
    if not vim.api.nvim_buf_is_valid(args.buf) then return end

    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })

    if not vim.g.ui_entered and args.event == 'UIEnter' then vim.g.ui_entered = true end

    if file ~= '' and buftype ~= 'nofile' and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
      vim.api.nvim_del_augroup_by_name 'NvFilePost'

      vim.schedule(function()
        vim.api.nvim_exec_autocmds('FileType', {})

        if vim.g.editorconfig then require('editorconfig').config(args.buf) end
      end)
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function() pcall(vim.treesitter.start) end,
})

local create_cmd = vim.api.nvim_create_user_command

create_cmd('TSInstallAll', function()
  local spec = require('lazy.core.config').plugins['nvim-treesitter']
  local opts = type(spec.opts) == 'table' and spec.opts or {}
  require('nvim-treesitter').install(opts.ensure_installed)
end, {})
-- lua/init.lua

vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  callback = function()
    -- Force a redraw of the statusline immediately
    vim.cmd 'redrawstatus'
  end,
})

vim.cmd.cnoreabbrev 'OS OverseerShell'
-- Only apply to specific filetypes or your own code files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'rust', 'go', 'python', 'lua', 'javascript', 'typescript' },
  callback = function() vim.opt_local.formatoptions:remove { 'c', 'r', 'o' } end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Check if the client supports inlay hints
    if client and client.server_capabilities.inlayHintProvider then
      -- Enable the hints for this specific buffer
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

vim.opt.number = true
vim.opt.relativenumber = true

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup('numbertoggle', { clear = true })

autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave' }, {
  group = 'numbertoggle',
  callback = function()
    if vim.opt.nu:get() then vim.opt.relativenumber = true end
  end,
})

autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter' }, {
  group = 'numbertoggle',
  callback = function()
    if vim.opt.nu:get() then vim.opt.relativenumber = false end
  end,
})
