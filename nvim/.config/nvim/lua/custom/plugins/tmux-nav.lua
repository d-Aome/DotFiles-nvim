local gh = require('helpers').gh
local map = vim.keymap.set
vim.pack.add { gh 'christoomey/vim-tmux-navigator' }

map('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { desc = 'Window: Left' })
map('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', { desc = 'Window: Down' })
map('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>', { desc = 'Window: Up' })
map('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', { desc = 'Window: Right' })
map('n', '<leader>\\', '<cmd>TmuxNavigatePrevious<cr>', { desc = 'Window: Previous' })
