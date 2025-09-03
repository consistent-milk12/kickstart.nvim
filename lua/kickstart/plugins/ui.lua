return {
  -- Highlight TODO/HACK/FIX comments with search integration
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false, -- Disable gutter signs
      highlight = { keyword = 'bg', after = '', before = '' }, -- Subtle highlights for TokyoNight
      keywords = {
        FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
        TODO = { icon = ' ', color = 'info' },
        HACK = { icon = ' ', color = 'warning' },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        PERF = { icon = ' ', color = 'default', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
      },
    },
  },

  -- Enhanced statusline with global status and better sections
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      -- Global statusline across all windows
      vim.opt.laststatus = 3

      require('lualine').setup({
        options = {
          theme = 'auto', -- Use TokyoNight's lualine theme
          globalstatus = true,
          component_separators = { left = '│', right = '│' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = { 'neo-tree', 'dashboard', 'lazy', 'help', 'trouble', 'oil' },
        },
        sections = {
          lualine_a = { { 'mode', fmt = function(s) return s:sub(1,1) end } },
          lualine_b = { 'branch', 'diff', { 'diagnostics', sources = { 'nvim_diagnostic' } } },
          lualine_c = { { 'filename', path = 1, symbols = { modified = ' [+]', readonly = ' []' } } },
          lualine_x = {
            -- Show pending lazy.nvim updates
            {
              function() return require('lazy.status').updates() end,
              cond = function() 
                return package.loaded['lazy.status'] and require('lazy.status').has_updates() 
              end,
              color = { fg = '#ff9e64' },
            },
            'encoding',
            'fileformat', 
            'filetype',
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        extensions = { 'quickfix', 'neo-tree', 'trouble', 'oil' },
      })
    end,
  },

  -- Modern surround plugin (Plugin.md 2025 recommendation)
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end,
  },

  -- Smart commenting (Plugin.md 2025 recommendation)
  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gcc', mode = 'n', desc = 'Comment toggle current line' },
      { 'gc', mode = { 'n', 'o' }, desc = 'Comment toggle linewise' },
      { 'gc', mode = 'x', desc = 'Comment toggle linewise (visual)' },
      { 'gbc', mode = 'n', desc = 'Comment toggle current block' },
      { 'gb', mode = { 'n', 'o' }, desc = 'Comment toggle blockwise' },
      { 'gb', mode = 'x', desc = 'Comment toggle blockwise (visual)' },
    },
    config = function()
      require('Comment').setup()
    end,
  },

  -- Indent guides for code structure visualization
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      indent = { char = '┆' },
      scope = { enabled = true, char = '▏', show_start = false, show_end = false },
      exclude = {
        filetypes = { 'help', 'neo-tree', 'dashboard', 'lazy', 'trouble', 'oil', 'markdown' },
        buftypes = { 'terminal', 'nofile', 'quickfix', 'prompt' },
      },
    },
  },

  -- Color preview in files (CSS, config files, etc.)
  {
    'catgoose/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      filetypes = { '*' },
      user_default_options = {
        names = false, -- Disable color names like 'red'
        RGB = true,    -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes 
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        css = true,    -- Enable CSS colors
        tailwind = true, -- Enable Tailwind colors
        mode = 'background', -- Display mode: 'background' or 'foreground'
      },
    },
  },

  -- Symbol reference illumination (highlight references under cursor)
  {
    'RRethy/vim-illuminate',
    event = 'VeryLazy',
    config = function()
      require('illuminate').configure({
        providers = { 'lsp', 'treesitter', 'regex' },
        delay = 120,
        filetypes_denylist = { 'neo-tree', 'dashboard', 'lazy', 'oil', 'trouble' },
        under_cursor = true,
      })
    end,
  },

  -- Enhanced quickfix UI (complements Trouble.nvim)
  {
    'stevearc/quicker.nvim',
    event = 'VeryLazy',
    opts = {
      keys = {
        {
          '>',
          function()
            require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = 'Expand quickfix context',
        },
        {
          '<',
          function()
            require('quicker').collapse()
          end,
          desc = 'Collapse quickfix context',
        },
      },
    },
    keys = {
      { '<leader>qq', function() require('quicker').toggle() end, desc = '[Q]uickfix: toggle' },
      { '<leader>ql', function() require('quicker').toggle({ loclist = true }) end, desc = '[Q]uickfix: toggle [L]oclist' },
    },
  },

  -- Keep mini.ai for better text objects (no conflict)
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
    end,
  },
}