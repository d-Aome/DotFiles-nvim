local M = {}
M.gh = function(repo) return 'https://github.com/' .. repo end

M.on_attach = function(client, bufnr) end
return M
