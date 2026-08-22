dofile(vim.g.base46_cache .. 'telescope')

local M = {}
M.keys = {
  -- ========================================== --
  -- Files & Generic
  -- ========================================== --
  {
    '<leader>ff',
    function()
      require('telescope.builtin').find_files()
    end,
    desc = 'Find Files',
  },
  {
    '<leader>fa',
    function()
      require('telescope.builtin').find_files { follow = true, no_ignore = true, hidden = true }
    end,
    desc = 'Find All (Hidden/Ignored)',
  },
  {
    '<leader><leader>',
    function()
      require('telescope.builtin').buffers()
    end,
    desc = 'Find Buffers',
  },

  -- ========================================== --
  -- Search & Grep
  -- ========================================== --
  {
    '<leader>fw',
    function()
      require('telescope.builtin').grep_string()
    end,
    desc = 'Find Current Word',
  },
  {
    '<leader>fg',
    function()
      require('telescope.builtin').live_grep()
    end,
    desc = 'Grep (Root Dir)',
  },
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
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end,
    desc = 'Fuzzy Find in Buffer',
  },

  -- ========================================== --
  -- Neovim Internals
  -- ========================================== --
  {
    '<leader>fh',
    function()
      require('telescope.builtin').help_tags()
    end,
    desc = 'Find Help',
  },
  {
    '<leader>fk',
    function()
      require('telescope.builtin').keymaps()
    end,
    desc = 'Find Keymaps',
  },
  {
    '<leader>fd',
    function()
      require('telescope.builtin').diagnostics()
    end,
    desc = 'Find Diagnostics',
  },
  {
    '<leader>fr',
    function()
      require('telescope.builtin').resume()
    end,
    desc = 'Resume Last Search',
  },
  {
    '<leader>fn',
    function()
      require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
    end,
    desc = 'Search Neovim Config',
  },

  -- ========================================== --
  -- Custom Integrations (Oil)
  -- ========================================== --
  {
    '<leader>fo',
    function()
      -- Find the git root, or fallback to the current working directory
      local current_file = vim.api.nvim_buf_get_name(0)
      local start_path = current_file ~= '' and current_file or vim.fn.getcwd()
      local git_root = vim.fs.root(start_path, { '.git' }) or vim.fn.getcwd()

      require('telescope.builtin').find_files {
        prompt_title = '< Open Directory in Oil >',
        -- Set Telescope's starting directory to the git root
        cwd = git_root,
        -- This command forces Telescope to only show directories
        find_command = { 'fd', '--type', 'd', '--hidden', '--exclude', '.git' },

        attach_mappings = function(prompt_bufnr, map)
          -- Require actions here so they don't load at startup!
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'

          -- Overwrite the default "Enter" action
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)

            -- Get the selected directory path
            local selection = action_state.get_selected_entry()

            -- Open Oil at that specific path
            if selection then
              require('oil').open(selection.path)
            end
          end)
          return true
        end,
      }
    end,
    desc = 'Find directory and open in Oil (Git Root)',
  },
  {
    '<leader>f.',
    function()
      require('telescope').extensions.frecency.frecency {}
    end,
  },
  {
    '<leader>fc',
    function()
      require('telescope').extensions.frecency.frecency {
        workspace = 'CWD',
      }
    end,
  },
}

M.opts = {
  defaults = {
    prompt_prefix = '   ',
    selection_caret = ' ',
    entry_prefix = ' ',
    sorting_strategy = 'ascending',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
      },
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
      n = { ['q'] = require('telescope.actions').close },
    },
  },

  extensions_list = { 'themes', 'terms' },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
    },
    frecency = {
      db_safe_mode = false,
    },
  },
}

return M
