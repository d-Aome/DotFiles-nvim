local gh = require('helpers').gh
local map = vim.keymap.set
vim.pack.add {
    gh 'ThePrimeagen/harpoon',
}

local harpoon = require 'harpoon'

-- REQUIRED
harpoon:setup { settings = { save_on_toggle = true, sync_on_ui_close = true } }

-- Actions
map('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon: Add File' })
map('n', '<leader>he', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon: Menu' })

-- Navigation (1-9)
for i = 1, 9 do
    map('n', '<leader>' .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon: Go to ' .. i })
end
vim.keymap.set('n', '<C-h>', function() harpoon:list():select(1) end)
vim.keymap.set('n', '<C-t>', function() harpoon:list():select(2) end)
vim.keymap.set('n', '<C-n>', function() harpoon:list():select(3) end)
vim.keymap.set('n', '<C-s>', function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set('n', '<C-S-P>', function() harpoon:list():prev() end)
vim.keymap.set('n', '<C-S-N>', function() harpoon:list():next() end)

-- basic telescope configuration
local function toggle_telescope(harpoon_files)
    local conf = require('telescope.config').values
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require('telescope.pickers')
        .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
                results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
        })
        :find()
end

vim.keymap.set('n', '<C-e>', function() toggle_telescope(harpoon:list()) end, { desc = 'Open harpoon window' })
