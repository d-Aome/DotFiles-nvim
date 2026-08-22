require('crates').setup {
    completion = {
        cmp = {
            enabled = true,
        },
        crates = {
            enabled = true,
            max_results = 15,
            min_chars = 0,
        },
        blink = {
            use_custom_kind = true,
        },
    },
    lsp = {
        enabled = true,
        actions = true,
        name = 'crate.nvim',
        completion = true,
        hover = true,
    },
}
