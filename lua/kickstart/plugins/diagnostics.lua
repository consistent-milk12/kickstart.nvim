return {
  -- Modern inline diagnostics display
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup {
        preset = 'modern',
        options = {
          show_source = false,
          throttle = 100, -- Balanced performance
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
          },
          multilines = false,
          show_all_diags_on_cursorline = true, -- Better UX in practice
          -- Enhanced visual options for TokyoNight
          softwrap = 30, -- Wrap long messages
          multiple_diag_under_cursor = true,
          -- Exclude markdown files from inline diagnostics (too noisy)
          exclude_filetypes = { 'markdown', 'text' },
          -- Aesthetic improvements
          break_line = {
            enabled = true,
            after = 50, -- Break lines longer than 50 characters
          },
          virt_texts = {
            priority = 2048, -- High priority to show over other virtual text
          },
        },
        signs = {
          left = '',
          right = '',
          diag = '●',
          arrow = ' ',
          up_arrow = ' ',
          vertical = '│',
          vertical_end = '└',
        },
      }
      
      -- Apply TokyoNight-compatible highlights
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = 'tokyonight*',
        callback = function()
          local colors = require('tokyonight.colors').setup()
          
          -- Inline diagnostic highlights
          vim.api.nvim_set_hl(0, 'TinyInlineDiagnosticVirtualTextError', { 
            fg = colors.red1, 
            bg = 'NONE',
            italic = true 
          })
          vim.api.nvim_set_hl(0, 'TinyInlineDiagnosticVirtualTextWarn', { 
            fg = colors.yellow, 
            bg = 'NONE',
            italic = true 
          })
          vim.api.nvim_set_hl(0, 'TinyInlineDiagnosticVirtualTextInfo', { 
            fg = colors.blue, 
            bg = 'NONE',
            italic = true 
          })
          vim.api.nvim_set_hl(0, 'TinyInlineDiagnosticVirtualTextHint', { 
            fg = colors.teal, 
            bg = 'NONE',
            italic = true 
          })
          
          -- Diagnostic arrows/connectors
          vim.api.nvim_set_hl(0, 'TinyInlineDiagnosticVirtualTextArrow', { 
            fg = colors.comment, 
            bg = 'NONE' 
          })
        end,
      })
      
      -- Apply highlights immediately if TokyoNight is loaded
      if vim.g.colors_name and vim.g.colors_name:match('tokyonight') then
        vim.cmd('doautocmd ColorScheme ' .. vim.g.colors_name)
      end
    end,
  },

  -- Enhanced diagnostic navigation and viewing
  {
    'folke/trouble.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
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
        '<leader>xs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>xl',
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
      -- Completely disable treesitter to prevent decoration provider errors
      local ok, ts = pcall(require, 'nvim-treesitter')
      if ok then
        -- Temporarily disable treesitter highlight for trouble buffers
        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'trouble',
          callback = function()
            vim.treesitter.stop()
          end,
        })
      end

      require('trouble').setup {
        -- Window and behavior settings
        auto_close = false, -- Don't auto-close to reduce flicker
        auto_open = false, -- Don't auto-open to reduce errors
        auto_preview = false, -- Disable auto-preview to reduce treesitter calls
        auto_refresh = false, -- Manual refresh to avoid spam
        focus = false, -- Don't auto-focus to reduce errors
        follow = false, -- Don't follow cursor to reduce treesitter calls

        -- Performance settings
        max_items = 200, -- Increased back for functionality
        multiline = false, -- Disable multiline to avoid treesitter parsing

        -- Completely disable treesitter integration
        use_diagnostic_signs = false, -- Don't use diagnostic signs

        -- Simple window configuration
        win = {
          border = 'single', -- Use simple border
          size = { height = 0.25 },
        },

        -- Disable preview to avoid treesitter issues
        preview = {
          type = 'main',
          scratch = true,
        },

        -- Simple modes configuration without treesitter features
        modes = {
          diagnostics = {
            groups = {},
            format = '{severity_icon} {filename} {pos}: {message}',
          },
        },

        -- Completely disable all treesitter-related features
        decorations = {
          treesitter = false,
        },

        -- Disable any treesitter-based rendering
        render = {
          max_value = 999,
          indent = {
            top = 0,
            middle = '',
            last = '',
          },
        },
      }
    end,
  },
}
