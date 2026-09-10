local nvchad_menu = require('nvchad.blink').menu

-- 2. Force the padding to be a valid number
if nvchad_menu.draw and nvchad_menu.draw.padding then nvchad_menu.draw.padding = 1 end

return {
  -- Your custom nvim-cmp style mappings
  snippets = {
    preset = 'luasnip',
  },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    keyword = {
      range = 'prefix',
    },
    list = { selection = { preselect = true, auto_insert = false } },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = {
        border = 'double',
        max_width = 80,
      },
    },
    ghost_text = { enabled = false },
    accept = {
      auto_brackets = { enabled = true },
    },
    menu = nvchad_menu,
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
    default = { 'lsp', 'path', 'snippets', 'lazydev' },
    providers = {
      snippets = {
        min_keyword_length = 2,
        score_offset = 2,
        max_items = 10,
      },
      lsp = {
        min_keyword_length = 0,
        score_offset = 4,
      },
      path = {
        min_keyword_length = 4,
        score_offset = 2,
      },
      buffer = {
        enabled = false,
        min_keyword_length = 7,
      },
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 5 },
    },
  },
}
