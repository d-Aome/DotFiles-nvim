require 'nvchad.autocmds'

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
  callback = function()
    vim.opt_local.formatoptions:remove { 'c', 'r', 'o' }
  end,
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
    if vim.opt.nu:get() then
      vim.opt.relativenumber = true
    end
  end,
})

autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter' }, {
  group = 'numbertoggle',
  callback = function()
    if vim.opt.nu:get() then
      vim.opt.relativenumber = false
    end
  end,
})
