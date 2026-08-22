local spec_treesitter = require('mini.ai').gen_spec.treesitter

require('mini.ai').setup {
    -- Table with textobject id as fields, textobject specification as values.
    -- Also use this to disable builtin textobjects. See |MiniAi.config|.
    custom_textobjects = {
        F = spec_treesitter { a = '@function.outer', i = '@function.inner' },
        c = spec_treesitter {
            a = { '@conditional.outer', '@loop.outer' },
            i = { '@conditional.inner', '@loop.inner' },
        },
    },

    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
        -- Main textobject prefixes
        around = 'a',
        inside = 'i',

        -- Next/last textobjects
        -- NOTE: These override built-in LSP selection mappings on Neovim>=0.12
        -- Map LSP selection manually to use it (see `:h MiniAi.config`)
        around_next = 'aN',
        inside_next = 'iN',
        around_last = 'al',
        inside_last = 'il',

        -- Move cursor to corresponding edge of `a` textobject
        goto_left = 'g[',
        goto_right = 'g]',
    },

    -- Number of lines within which textobject is searched
    n_lines = 50,

    -- How to search for object (first inside current line, then inside
    -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
    -- 'cover_or_nearest', 'next', 'prev', 'nearest'.
    search_method = 'cover_or_next',

    -- Whether to disable showing non-error feedback
    -- This also affects (purely informational) helper messages shown after
    -- idle time if user input is required.
    silent = false,
}

require('mini.surround').setup()
require('mini.diff').setup()
