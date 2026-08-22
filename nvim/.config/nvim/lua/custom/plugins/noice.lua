-- lua/custom/plugins/init.lua
vim.pack.add {
    gh 'MunifTanjim/nui.nvim',
    gh 'rcarriga/nvim-notify',
    gh 'folke/noice.nvim',
}

-- lua/configs/noice.lua
local M = {}

-- Your existing notify config
M.notify_config = function()
    require('notify').setup {
        background_colour = '#000000',

        -- local buf = an integer
        -- local notification = a table with the notify.Record format
        highlights = {
            title = 'NotifyTitle',
            icon = 'NotifyIcon',
            border = 'NotifyBorder',
            body = 'NotifyBody',
        },
        merge_duplicates = true,
    }
end

-- Your existing noice opts
M.noice_opts = {
    notify = { enabled = true },
    views = {
        cmdline_popup = {
            position = {
                row = '40%', -- Adjust this percentage to move it up or down
                col = '50%',
            },
            size = {
                width = 60,
                height = 'auto',
            },
        },
    },
    popupmenu = {
        relative = 'editor',
        position = {
            row = '53%', -- Positions the suggestion menu just below the centered cmdline
            col = '50%',
        },
    },
    lsp = {
        enabled = false,
        hover = {
            enabled = false,
        },
        signature = {
            enabled = false,
            opts = {
                focus = false,
            },
        },
        auto_open = {
            enabled = false,
        },
    },
    presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
    },
    cmdline = {
        command_palette = false,
    },
}

-- ========================================== --
-- Native "VeryLazy" Implementation           --
-- ========================================== --

-- When Kickstart requires this file, it creates an autocommand.
-- This autocommand waits until Neovim has fully started (VimEnter),
-- then runs the setups for notify and noice.
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        -- 1. Setup notify first (since noice depends on it)
        if type(M.notify_config) == 'function' then
            M.notify_config()
        else
            require('notify').setup(M.notify_config)
        end

        -- Set notify as the default notification provider
        vim.notify = require 'notify'

        -- 2. Setup noice
        require('noice').setup(M.noice_opts)
    end,
    once = true, -- Ensures this only runs exactly once during startup
})

vim.keymap.set('n', '<leader>dn', '<cmd>NoiceDismiss<CR>', { desc = 'Dismiss Notifications' })
return M
