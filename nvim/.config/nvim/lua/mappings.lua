local map = vim.keymap.set

-- ========================================================================== --
--                               WHICH-KEY SETUP                              --
-- ========================================================================== --
-- This registers the group names so the menu shows "+Find", "+Git", etc.
local wk = require 'which-key'
wk.add {
  { '<leader>c', group = 'Code / LSP' },
  { '<leader>f', group = 'Find (Telescope)' },
  { '<leader>g', group = 'Git' },
  { '<leader>h', group = 'Harpoon' },
  { '<leader>n', group = 'Notes / Noice' },
  { '<leader>t', group = 'Toggle / Themes' },
  { '<leader>w', group = 'Window / WhichKey' },
  { '<leader>x', group = 'Diagnostics (Trouble)' },
}

-- ========================================================================== --
--                             CORE KEYBINDINGS                               --
-- ========================================================================== --
map('t', '<ESC>', '<C-\\><C-n>')
map('n', '<leader>ch', '<cmd>NvCheatsheet<CR>', { desc = 'toggle nvcheatsheet' })
map('c', '<ESC>', '<C-c>')
-- -- File & Window Management --
map({ 'n', 'v' }, '<leader>s', '<cmd>w<cr>', { desc = 'Save file', silent = false })
map('n', '<leader>q', '<cmd>close<cr>', { desc = 'Window: Close' })
map('n', 'Q', '<nop>', { desc = 'Disable Ex Mode' })

-- -- Navigation between Buffer's --
map('n', '<leader>nb', '<cmd>bn<CR>', { desc = 'Go to [N]ext [B]uffer' })
map('n', '<leader>pb', '<cmd>bp<CR>', { desc = 'Go to [P]revious [B]uffer' })

-- In init.lua
map('n', '\'', '`', { desc = 'Jump to exact mark position' })
-- -- Navigation & Centering --
map({ 'n', 'v' }, '<C-d>', '<C-d>zz', { desc = 'Jump Down Half Page (Center)' })
map({ 'n', 'v' }, '<C-u>', '<C-u>zz', { desc = 'Jump Up Half Page (Center)' })
map('n', 'n', 'nzzzv', { desc = 'Next Match (Center)' })
map('n', 'N', 'Nzzzv', { desc = 'Prev Match (Center)' })
-- -- Line Manipulation & Yanking --
map('n', 'Y', 'y$', { desc = 'Yank to end of line' })

map('n', 'J', function()
  if vim.bo.filetype == 'rust' then
    vim.cmd.RustLsp 'joinLines'
  else
    vim.cmd 'normal! mzJ`z'
  end
end, { desc = 'Join lines (keep cursor)' })

map('n', '<leader>o', 'o<ESC>', { desc = 'Insert line below' })
map('n', '<leader>O', 'O<ESC>', { desc = 'Insert line above' })

-- -- Visual Mode Moves (The Primeagen mappinngs) --
map('v', '<C-j>', ':m \'>+1<CR>gv=gv', { desc = 'Move Line Down' })
map('v', '<C-k>', ':m \'<-2<CR>gv=gv', { desc = 'Move Line Up' })
map('v', '<', '<gv', { desc = 'Indent Left' })
map('v', '>', '>gv', { desc = 'Indent Right' })
map('x', '<leader>p', '"_dP', { desc = 'Paste over selection (Keep clipboard)' })

-- -- TMUX Navigation --
map('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { desc = 'Window: Left' })
map('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', { desc = 'Window: Down' })
map('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>', { desc = 'Window: Up' })
map('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', { desc = 'Window: Right' })
map('n', '<leader>\\', '<cmd>TmuxNavigatePrevious<cr>', { desc = 'Window: Previous' })

-- -- Utility --
map('n', '<leader>n', '<cmd>nohlsearch<CR>', { silent = true, desc = 'Clear highlight' })
map('n', '<leader>/', 'gcc', { desc = 'Toggle Comment', remap = true })
map('v', '<leader>/', 'gc', { desc = 'Toggle Comment', remap = true })
map('n', '-', '<CMD>Oil<CR>', { desc = 'Open Parent Directory (Oil)' })
map('n', 'gx', '<cmd>:URLOpenUnderCursor<CR>')
-- ========================================================================== --
--                           LSP & FORMATTING                                --
-- ========================================================================== --
map('n', '<leader>roc', function()
  vim.cmd.RustLsp 'openCargo'
end, { desc = 'RustLsp: Open Cargo.toml' })

map('n', '<leader>rod', function()
  vim.cmd.RustLsp 'openDocs'
end, { desc = 'Rust: Open Docs (under cursor)' })

vim.keymap.set({ 'n', 'x' }, '<leader>ca', function()
  if vim.bo.filetype == 'rust' then
    vim.cmd.RustLsp 'codeAction'
    return
  end
  require('tiny-code-action').code_action()
end, { noremap = true, silent = true })
map('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP Diagnostic Loclist' })

-- Formatting
map({ 'n', 'x' }, '<leader>fm', function()
  require('conform').format { lsp_fallback = true }
end, { desc = 'Format Buffer' })

map('n', 'K', function()
  -- Check if we are in a Cargo.toml file
  if vim.fn.expand '%:t' == 'Cargo.toml' then
    require('crates').show_popup()
  else
    vim.cmd 'Lspsaga hover_doc'
  end
end, { desc = 'Hover doc (Lspsaga / crates.nvim)' })

vim.keymap.set('n', 'gK', function()
  require('hover').enter()
end, { desc = 'hover.nvim (enter)' })

-- Todo comments
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })

vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })

-- You can also specify a list of valid jump keywords

vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next { keywords = { 'ERROR', 'WARNING' } }
end, { desc = 'Next error/warning todo comment' })
-- -- Git (Neogit) --
map('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Open Neogit' })
-- -- Themes (NvChad) --
map('n', '<leader>th', function()
  require('nvchad.themes').open()
end, { desc = 'NvChad Themes' })

-- -- Trouble --
map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Trouble: Diagnostics' })
map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Trouble: Buffer Diagnostics' })
map('n', '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Trouble: Symbols' })
map(
  'n',
  '<leader>xl',
  '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
  { desc = 'Trouble: LSP Definitions' }
)
map('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Trouble: Loclist' })
map('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Trouble: Quickfix' })
map('n', '<leader>xt', '<cmd>TodoQuickFix<CR>', { desc = 'Trouble: Todo\'s' })

-- -- Noice --
map('n', '<leader>nd', '<cmd>NoiceDismiss<CR>', { desc = 'Dismiss Notifications' })

-- -- WhichKey Direct --
map('n', '<leader>wK', '<cmd>WhichKey <CR>', { desc = 'Show All Keymaps' })
map('n', '<leader>wk', function()
  vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ')
end, { desc = 'WhichKey Lookup' })
-- Overseer --

map('n', '<leader>to', '<cmd>OverseerToggle <CR>', { desc = 'Toggle Overseer Output Buffer' })
map('n', '<leader>cd', '<cmd>Codedocs<CR>', { desc = 'Insert annotation' })
vim.keymap.set('n', '<leader>ih', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle Inlay Hints' })

map('x', '<leader>re', ':Refactor extract ')
map('x', '<leader>rf', ':Refactor extract_to_file ')

map('x', '<leader>rv', ':Refactor extract_var ')

map({ 'n', 'x' }, '<leader>ri', ':Refactor inline_var')

map('n', '<leader>rI', ':Refactor inline_func')

map('n', '<leader>rb', ':Refactor extract_block')
map('n', '<leader>rbf', ':Refactor extract_block_to_file')

-- ========================================================================== --
--                                 DiffView                                   --
-- ========================================================================== --

-- ========================================================================== --
--                                 HARPOON                                    --
-- ========================================================================== --
local harpoon = require 'harpoon'
harpoon:setup { settings = { save_on_toggle = true, sync_on_ui_close = true } }

-- Actions
map('n', '<leader>a', function()
  harpoon:list():add()
end, { desc = 'Harpoon: Add File' })
map('n', '<leader>he', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Harpoon: Menu' })

-- Navigation (1-9)
for i = 1, 9 do
  map('n', '<leader>' .. i, function()
    harpoon:list():select(i)
  end, { desc = 'Harpoon: Go to ' .. i })
end
