local gh = require('helpers').gh

vim.pack.add {
    gh 'nvim-lua/plenary.nvim', -- Required by both Telescope and Harpoon
    gh 'nvim-telescope/telescope.nvim',
    gh 'andrew-george/telescope-themes',
    gh 'nvim-telescope/telescope-fzf-native.nvim',
    gh 'nvim-telescope/telescope-frecency.nvim',
}

local M = {}

-- ========================================== --
-- 1. Configuration Options
-- ========================================== --
M.opts = {
    defaults = {
        prompt_prefix = '   ',
        selection_caret = ' ',
        entry_prefix = ' ',
        sorting_strategy = 'ascending',
        layout_config = {
            horizontal = { prompt_position = 'top', preview_width = 0.55 },
            width = 0.87,
            height = 0.80,
        },
        file_ignore_patterns = {
            'node_modules/',
            '.git/',
            'package%-lock%.json',
            'out/',
            'build/',
            'dest/',
            'Debug/',
            '*.o',
            '*.so',
            '*.a',
            '*.jpg',
            '*.jpeg',
            '*.png',
            '*.gif',
            '*.bmp',
            '*.tiff',
            'vendor/',
            'target/',
            'generated/',
        },
        mappings = {
            n = {
                -- Safe to require directly now since we load on startup
                ['q'] = require('telescope.actions').close,
            },
        },
    },
    extensions_list = { 'themes' },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
        frecency = {
            db_safe_mode = false,
        },
    },
}

-- ========================================== --
-- 2. Immediate Setup & Extensions
-- ========================================== --
local telescope = require 'telescope'

telescope.setup(M.opts)
telescope.load_extension 'fzf'
telescope.load_extension 'frecency'

for _, ext in ipairs(M.opts.extensions_list or {}) do
    telescope.load_extension(ext)
end

-- ========================================== --
-- 3. Keymaps
-- ========================================== --
M.keys = {
    { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find Files' },
    {
        '<leader>fa',
        function() require('telescope.builtin').find_files { follow = true, no_ignore = true, hidden = true } end,
        desc = 'Find All (Hidden/Ignored)',
    },
    { '<leader><leader>', function() require('telescope.builtin').buffers() end, desc = 'Find Buffers' },
    { '<leader>fw', function() require('telescope.builtin').grep_string() end, desc = 'Find Current Word' },
    { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = 'Grep (Root Dir)' },
    {
        '<leader>f/',
        function()
            require('telescope.builtin').live_grep { grep_open_files = true, prompt_title = 'Live Grep (Open Files)' }
        end,
        desc = 'Grep (Open Files)',
    },
    {
        '<leader>fz',
        function()
            require('telescope.builtin').current_buffer_fuzzy_find(
                require('telescope.themes').get_dropdown { winblend = 10, previewer = false }
            )
        end,
        desc = 'Fuzzy Find in Buffer',
    },
    { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Find Help' },
    { '<leader>fk', function() require('telescope.builtin').keymaps() end, desc = 'Find Keymaps' },
    { '<leader>fd', function() require('telescope.builtin').diagnostics() end, desc = 'Find Diagnostics' },
    { '<leader>fr', function() require('telescope.builtin').resume() end, desc = 'Resume Last Search' },
    {
        '<leader>fn',
        function() require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' } end,
        desc = 'Search Neovim Config',
    },
    {
        '<leader>fo',
        function()
            require('telescope.builtin').find_files {
                prompt_title = '< Open Directory in Oil >',
                find_command = { 'fd', '--type', 'd', '--hidden', '--exclude', '.git' },
                attach_mappings = function(prompt_bufnr, map)
                    local actions = require 'telescope.actions'
                    local action_state = require 'telescope.actions.state'
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        if selection then require('oil').open(selection.path) end
                    end)
                    return true
                end,
            }
        end,
        desc = 'Find directory and open in Oil',
    },
    { '<leader>f.', function() require('telescope').extensions.frecency.frecency {} end, desc = 'Frecency Search' },
    {
        '<leader>fc',
        function() require('telescope').extensions.frecency.frecency { workspace = 'CWD' } end,
        desc = 'Frecency Search (CWD)',
    },
}

-- Register keymaps natively
for _, map in ipairs(M.keys) do
    vim.keymap.set('n', map[1], map[2], { desc = map.desc })
end

return M
