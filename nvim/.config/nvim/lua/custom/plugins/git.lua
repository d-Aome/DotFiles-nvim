local gh = require('helpers').gh
local map = vim.keymap.set

vim.pack.add {
    gh 'NeoGitOrg/neogit',
    gh 'sindrets/diffview.nvim',
    gh 'tpope/vim-fugitive',
    gh 'Chaitanyabsprip/fastaction.nvim',
}

map('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Open Neogit' })
