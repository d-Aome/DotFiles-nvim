local gh = require('helpers').gh

vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

-- `friendly-snippets` contains a variety of premade snippets.
--    See the README about individual language/framework/plugin snippets:
--    https://github.com/rafamadriz/friendly-snippets
--
vim.pack.add { gh 'rafamadriz/friendly-snippets' }
require('luasnip.loaders.from_vscode').lazy_load()
-- [[ Autocomplete Engine ]]
vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
    snippets = {
        preset = 'luasnip',
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
        trigger = {
            min_keyword_length = 2,
        },
        keyword = {
            range = 'prefix',
        },
        list = { selection = { preselect = true, auto_insert = false } },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = {
                border = 'double',
                max_width = 80,
            },
        },

        ghost_text = { enabled = false },
        accept = {
            auto_brackets = { enabled = true },
        },
    },
    fuzzy = {
        frecency = {
            enabled = false,
            path = vim.fn.stdpath 'state' .. '/blink/cmp/frecency.dat',
        },
        implementation = 'rust',
        sorts = {
            'exact',
            'score',
            'sort_text',
            'label',
        },
    },
    keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<ESC>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        -- LuaSnip jumps
        ['<A-k>'] = { 'snippet_forward', 'fallback' },
        ['<A-j>'] = { 'snippet_backward', 'fallback' },
    },

    cmdline = {
        enabled = true,
        keymap = {
            preset = 'none',
            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<Tab>'] = { 'show_and_insert', 'select_next', 'fallback' },
            ['<C-e>'] = { 'hide', 'fallback' },
            ['<ESC>'] = { 'hide', 'fallback' },
            ['<C-y>'] = { 'accept', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback' },
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        },
        completion = {
            list = {
                selection = {
                    preselect = true,
                    auto_insert = false,
                },
            },
            menu = { auto_show = true },
        },
        sources = function()
            local type = vim.fn.getcmdtype()
            -- Search forward and backward
            if type == '/' or type == '?' then return { 'buffer' } end
            -- Commands
            if type == ':' or type == '@' then return { 'cmdline', 'buffer' } end
            return {}
        end,
    },

    sources = {
        default = { 'lsp', 'path', 'snippets' },
        providers = {
            snippets = {
                min_keyword_length = 3,
                score_offset = 2,
                max_items = 10,
            },
            lsp = {
                min_keyword_length = 0,
                score_offset = 4,
                max_items = 10,
            },
            path = {
                min_keyword_length = 4,
                score_offset = 2,
                max_items = 5,
            },
        },
    },
}
