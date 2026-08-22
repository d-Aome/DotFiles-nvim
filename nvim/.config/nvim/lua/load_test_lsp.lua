local client = vim.lsp.start {
    name = 'flatbuffer-lsp',
    cmd = { '/home/david/flatbuffer-lsp/main' },
}

if not client then
    vim.notify 'Lsp didnt start properly'
    return
end

vim.api.nvim_clear_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
        vim.lsp.buf_attach_client(0, client)
    end,
})
