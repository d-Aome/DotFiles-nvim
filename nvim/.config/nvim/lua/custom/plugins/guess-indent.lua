local gh = require('helpers').gh

vim.pack.add({
    gh 'nmac/guess-indent.nvim',
}, {
    auto_cmd = true, -- Run automatically when opening a file
    override_editorconfig = false, -- If you have .editorconfig, use that instead
    filetype_exclude = { -- Don't run on these filetypes
        'netrw',
        'tutor',
    },
    buftype_exclude = {
        'help',
        'nofile',
        'terminal',
        'prompt',
    },
    on_tab_options = { -- A table of vim options when tabs are detected
        ['expandtab'] = true,
    },
    on_space_options = { -- A table of vim options when spaces are detected
        ['expandtab'] = true,
        ['tabstop'] = 'detected', -- If the option value is 'detected', The value is set to the automatically detected indent size.
        ['softtabstop'] = 'detected',
        ['shiftwidth'] = 'detected',
    },
})
