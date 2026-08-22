vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Check if the client supports inlay hints
        if client and client.server_capabilities.inlayHintProvider then
            -- Enable the hints for this specific buffer
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end,
})

local function set_solid_floats()
    -- Set your preferred background color
    -- You can use a hex string directly or fetch it from your theme's 'Normal' background
    local float_bg = '#16161e'

    -- Override the base floating window groups
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = float_bg })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = float_bg })
end

-- Run once on startup
set_solid_floats()

-- Re-apply on every Colorscheme change
vim.api.nvim_create_autocmd('ColorScheme', {
    callback = set_solid_floats,
})

local function disable_inlay_hint_bg()
    -- Setting bg to 'NONE' makes it transparent
    vim.api.nvim_set_hl(0, 'LspInlayHint', {
        bg = 'NONE',
        -- You might want to keep or adjust the foreground (fg)
        -- to ensure it's still readable
        fg = '#737aa2', -- Example: a muted color
        italic = true,
    })
end

-- Apply immediately
disable_inlay_hint_bg()

-- Re-apply on ColorScheme change to ensure the theme doesn't override it
vim.api.nvim_create_autocmd('ColorScheme', {
    callback = disable_inlay_hint_bg,
})
