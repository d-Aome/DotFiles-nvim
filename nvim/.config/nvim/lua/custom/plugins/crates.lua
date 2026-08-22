local gh = require('helpers').gh

vim.pack.add {
    gh 'saecki/crates.nvim',
    gh 'nvim-lua/plenary.nvim',
}

local function setup_crates()
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
end

-- Load only for Cargo.toml
vim.api.nvim_create_autocmd('BufRead', {
    pattern = 'Cargo.toml',
    callback = function()
        if not package.loaded['crates'] then setup_crates() end
    end,
})
