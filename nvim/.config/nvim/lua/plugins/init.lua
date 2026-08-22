return {
  -- ========================================================================== --
  --                              LSP & LANGUAGES                               --
  --          Servers, Autocompletion, and Language-Specific Plugins            --
  -- ========================================================================== --
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'lewis6991/async.nvim',
    },
    lazy = false,
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvchad.configs.lspconfig').defaults()
      require 'configs.lspconfig'
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lspconfig' },
    config = function()
      require 'configs.mason-lspconfig'
    end,
  },
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
      enabled = function(root_dir)
        if root_dir:match(vim.fn.stdpath 'config') then
          return true
        end
        return false
      end,
    },
  },
  { import = 'nvchad.blink.lazyspec' },
  {
    'saghen/blink.compat',
    version = '2.*',
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'saghen/blink.lib' },
    opts = require 'configs.blink',
    build = function()
      ---@diagnostic disable-next-line: undefined-field
      require('blink.cmp').build():pwait()
    end,
  },
  {
    'nvimdev/lspsaga.nvim',
    lazy = false,
    keys = {
      { '<leader>lf', '<cmd>Lspsaga finder<CR>', desc = 'LSPsaga finder' },
    },
    config = function()
      require('lspsaga').setup {}
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons', -- optional
    },
  },
  {
    'mrcjkb/rustaceanvim',
    ft = 'rust',
    lazy = false,
    keys = {
      { '<leader>ec', '<cmd>RustLsp explainError cycle<CR>', desc = ' Explain Error (Cycle)' },
    },
    init = function()
      -- By passing a function here, rustaceanvim will silently wait.
      -- When you finally open a .rs file, it will call this function,
      -- which loads mason-registry and returns your config table!
      vim.g.rustaceanvim = function()
        return require('configs.rust').setup()
      end
    end,
  },
  {
    'saecki/crates.nvim',
    ft = { 'toml' },
    tag = 'stable',
    config = function()
      require 'configs.crates'
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
  {
    'nvim-java/nvim-java',
    ft = 'java',
    dependencies = {},
    config = function()
      require('java').setup()
      vim.lsp.enable 'jdtls'
    end,
  },

  -- ========================================================================== --
  --                                TREESITTER                                  --
  --             Syntax Highlighting, Indentation & Language Parsers            --
  -- ========================================================================== --
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main', lazy = true },
      'HiPhish/rainbow-delimiters.nvim',
    },
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    event = { 'BufReadPost', 'BufNewFile' },
    opts = require('configs.treesitter').opts,
    config = require('configs.treesitter').setup,
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      require 'configs.rainbow'
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    lazy = true,
    ft = { 'markdown', 'codecompanion', 'Avante' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      latex = {
        enabled = true,
        converter = 'latex2text',
      },
      win_options = {
        conceallevel = { default = 3, rendered = 3 },
        wrap = { default = true, rendered = true },
        -- Add these to improve Java/Rust doc readability:
        linebreak = { default = true, rendered = true },
        breakindent = { default = true, rendered = true },
      },
    },
  },

  -- ========================================================================== --
  --                           FORMATTING & LINTING                             --
  --                   LSP Bridge, Formatting & Code Actions                    --
  -- ========================================================================== --
  {
    'zapling/mason-conform.nvim',
    event = 'VeryLazy',
    dependencies = { 'conform.nvim' },
    config = function()
      require 'configs.mason-conform'
    end,
  },
  {
    'stevearc/conform.nvim',
    events = 'BufWritePre',
    opts = {},
    config = function()
      require 'configs.conform'
    end,
  },
  {
    'rshkarin/mason-nvim-lint',
    event = 'VeryLazy',
    dependencies = { 'nvim-lint' },
    config = function()
      require 'configs.mason-lint'
    end,
  },
  {
    'mfussenegger/nvim-lint',
    opts = {},
    config = function()
      require 'configs.lint'
    end,
  },
  {
    -- snippet plugin
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    dependencies = { 'rafamadriz/friendly-snippets', enabled = false },
    opts = { history = true, updateevents = 'TextChanged,TextChangedI', enable_autosnippets = false },
    config = function(_, opts)
      require('luasnip').config.set_config(opts)
    end,
  },

  -- ========================================================================== --
  --                           DEBUGGING & TESTING                              --
  --                          DAP Engines and Neotest                           --
  -- ========================================================================== --
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    keys = require('configs.dap').keys,
    dependencies = {
      'igorlfs/nvim-dap-view',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
    config = function()
      require('configs.dap').core()
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = 'mfussenegger/nvim-dap',
    config = function()
      require('configs.dap').python()
    end,
  },
  {
    'leoluz/nvim-dap-go',
    ft = 'go',
    dependencies = 'mfussenegger/nvim-dap',
    config = function()
      require('configs.dap').go()
    end,
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('configs.dap').javascript()
    end,
  },
  {
    'nvim-neotest/neotest',
    keys = {
      {
        '<leader>tr',
        function()
          require('neotest').run.run()
        end,
        desc = 'Test: Run Nearest',
      },
      {
        '<leader>tso',
        function()
          require('neotest').output.open { enter = true }
        end,
        desc = 'Test: Show Output',
      },
      {
        '<leader>tf',
        function()
          if vim.bo.filetype == 'rust' then
            vim.cmd.RustLsp 'testables'
          else
            require('neotest').run.run(vim.fn.expand '%')
          end
        end,
        desc = 'Test: Run File',
      },
      {
        '<leader>ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = 'Test: Toggle Summary',
      },
    },

    dependencies = {
      'nvim-neotest/nvim-nio',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-jest',
      'nvim-neotest/neotest-python',
      {
        'fredrikaverpil/neotest-golang', -- Installation
        version = '*',
        dependencies = {
          'leoluz/nvim-dap-go',
        },
      },
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'rustaceanvim.neotest',
          require 'neotest-python',
          require 'neotest-golang',
          require 'neotest-jest' {
            jetCommand = 'npm test --',
            jestArguments = function(defaultArgs, _)
              return defaultArgs
            end,
            jestConfigFile = 'custom.jest.config.ts',
            env = { CI = true },
            cwd = function(_)
              return vim.fn.getcwd()
            end,
            isTestFile = require('neotest-jest.jest-util').defaultIsTestFile,
          },
        },
      }
    end,
  },

  -- ========================================================================== --
  --                           NAVIGATION & SEARCH                              --
  --                 Telescope, File Explorers, Harpoon & Marks                 --
  -- ========================================================================== --
  {
    'nvim-telescope/telescope-frecency.nvim',
    version = '*',
    config = function()
      require('telescope').load_extension 'frecency'
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    ---@diagnostic disable-next-line: different-requires
    keys = require('configs.telescope').keys,
    opts = function()
      ---@diagnostic disable-next-line: different-requires
      return require('configs.telescope').opts
    end,
    config = function(_, opts)
      local telescope = require 'telescope'
      telescope.setup(opts)
      telescope.load_extension 'fzf'

      for _, ext in ipairs(opts.extensions_list or {}) do
        telescope.load_extension(ext)
      end
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',

    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      local map = vim.keymap.set
      local conf = require('telescope.config').values

      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      map('n', '<leader>e', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
    end,
  },
  {
    'stevearc/oil.nvim',
    dependencies = { 'benomahony/oil-git.nvim' },
    cmd = 'Oil',
    opts = require 'configs.oil',
    config = function(_, opts)
      ---@diagnostic disable-next-line: different-requires
      require('oil').setup(opts)
    end,
  },
  { 'nvim-tree/nvim-tree.lua', enabled = false },
  {
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    opts = {
      builtin_marks = { '.', '<', '>' },
      refresh_interval = 250, -- Force it to safely debounce updates (in ms)
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    },
  },
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
  },

  -- ========================================================================== --
  --                             GIT INTEGRATION                                --
  --                          Neogit, Fugitive & Diffview                       --
  -- ========================================================================== --
  {
    'NeoGitOrg/neogit',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Neogit',
    keys = {
      keys = {},
    },
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Git' },
  },

  -- ========================================================================== --
  --                             UI & DIAGNOSTICS                               --
  --             Themes, Status Line, Inline Diagnostics & FastAction           --
  -- ========================================================================== --
  {
    'chrisgrieser/nvim-lsp-endhints',
    event = 'LspAttach',
    opts = {}, -- required, even if empty
    config = function()
      require('lsp-endhints').setup {
        label = {
          truncateAtChars = 30,
          padding = 1,
          marginLeft = 0,
          sameKindSeparator = ', ',
        },
      }
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'rcarriga/nvim-notify',
        config = require('configs.noice').notify_config,
      },
    },
    opts = function()
      return require('configs.noice').noice_opts
    end,
  },
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble',
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'LspAttach',
    priority = 1000,
    opts = require('configs.tiny').opts,
    config = function(_, opts)
      require('tiny-inline-diagnostic').setup(opts)
      vim.diagnostic.config { virtual_text = false }
    end,
  },
  {
    'rachartier/tiny-code-action.nvim',
    dependencies = {
      -- optional picker via telescope
      { 'nvim-telescope/telescope.nvim' },
      -- optional picker via fzf-lua
      { 'ibhagwan/fzf-lua' },
      -- .. or via snacks
      {
        'folke/snacks.nvim',
        opts = {
          terminal = {},
        },
      },
    },
    event = 'LspAttach',
    opts = {},
  },
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = require 'configs.todo-comments',
    config = function(_, opts)
      require('todo-comments').setup(opts)
    end,
  },

  -- ========================================================================== --
  --                           UTILITIES & WORKFLOW                             --
  --                   Workflow Enhancements & Helper Tools                     --
  -- ========================================================================== --
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'User FilePost',
    opts = {
      indent = { char = '│', highlight = 'IblChar' },
      scope = {
        char = '│',
        show_start = false,
        show_end = false,
        highlight = 'IblScopeChar',
      },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. 'blankline')

      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require('ibl').setup(opts)

      dofile(vim.g.base46_cache .. 'blankline')
    end,
  },
  {
    'jeangiraldoo/codedocs.nvim',
    lazy = false,
    config = function()
      require('codedocs').setup {}
    end,
  },
  { 'wakatime/vim-wakatime', event = 'VeryLazy' },
  {
    'numToStr/Comment.nvim',
    opts = {},
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = { '<leader>', '<c-w>', '"', '\'', '`', 'c', 'v', 'g' },
    cmd = 'WhichKey',
    opts = function()
      dofile(vim.g.base46_cache .. 'whichkey')
    end,
  },
  {
    'nmac427/guess-indent.nvim',
    event = 'VeryLazy',
    config = function()
      require 'configs.guess-indent'
    end,
  },
  {
    'nvim-mini/mini.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    version = false,
    config = function()
      require 'configs.mini'
    end,
  },
  {
    'Civitasv/cmake-tools.nvim',
    ft = { 'c', 'cpp', 'objc', 'objcpp', 'cmake' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/overseer.nvim',
    },
    config = function()
      local cmake_config = require 'configs.cmake-tools'
      ---@diagnostic disable-next-line: different-requires
      require('cmake-tools').setup(cmake_config.get_opts())
    end,
  },
  {
    'stevearc/overseer.nvim',
    lazy = false,
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {},
    config = function(_)
      require('overseer').setup()
    end,
  },
  {
    'chrisgrieser/nvim-early-retirement',
    config = true,
    event = 'VeryLazy',
  },
  {
    'DrKJeff16/boolean-toggle.nvim',
    opts = {},
    config = function()
      require('boolean-toggle').setup {
        keymaps = {
          toggle = '<CR>', -- Toggle on ENTER
          to_false = nil,
          to_true = nil,
        },
      }
    end,
  },
  -- lazy.nvim
  {
    'sontungexpt/url-open',
    event = 'VeryLazy',
    cmd = 'URLOpenUnderCursor',
    config = function()
      local status_ok, url_open = pcall(require, 'url-open')
      if not status_ok then
        return
      end
      url_open.setup {}
    end,
  },
}
