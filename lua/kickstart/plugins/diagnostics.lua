return {
  -- Modern inline diagnostics display
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup({
        preset = 'modern', -- or 'classic', 'minimal', 'powerline', etc
        options = {
          -- Show source if there are multiple diagnostic sources
          show_source = false,
          -- Throttle diagnostic updates for performance
          throttle = 20,
          -- Only show errors and warnings by default
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
          },
          -- Enable multiline diagnostic messages
          multilines = true,
          -- Show all diagnostics on the line
          show_all_diags_on_cursorline = true,
        },
        signs = {
          left = ' ',
          right = ' ',
          diag = '●',
          arrow = '    ',
          up_arrow = '    ',
          vertical = ' │',
          vertical_end = ' └',
        },
      })
    end,
  },

  -- Enhanced diagnostic navigation and viewing
  {
    'folke/trouble.nvim',
    dependencies = { 'echasnovski/mini.icons' },
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
    config = function()
      require('trouble').setup({
        -- Automatically close trouble when there are no items
        auto_close = true,
        -- Automatically focus the trouble window when opened
        focus = true,
        -- Follow the cursor in the trouble window
        follow = true,
        -- Show indent guides for nested items
        indent_guides = true,
        -- Maximum height for the trouble window
        max_items = 200,
        -- Window configuration
        win = {
          border = 'rounded',
          size = { height = 0.3 },
        },
        -- Configure preview window
        preview = {
          type = 'split',
          relative = 'win',
          position = 'right',
          size = 0.3,
        },
        -- Integration with telescope
        modes = {
          diagnostics = {
            groups = {
              { 'filename', format = '{file_icon} {basename:Title} {count}' },
            },
          },
        },
      })
    end,
  },
}