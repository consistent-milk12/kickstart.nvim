-- Modern buffer tabs with diagnostics integration and TokyoNight theming
-- Provides visual buffer management with LSP diagnostics and git status
return {
  'akinsho/bufferline.nvim',
  enabled = false, -- Disabled bufferline
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  keys = {
    { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = '󰐃 Toggle Buffer Pin' },
    { '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<cr>', desc = '󰐃 Delete Non-Pinned Buffers' },
    { '<leader>br', '<cmd>BufferLineCloseRight<cr>', desc = '󰐃 Delete Buffers to Right' },
    { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', desc = '󰐃 Delete Buffers to Left' },
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = '󰐃 Prev Buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = '󰐃 Next Buffer' },
    { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = '󰐃 Prev Buffer' },
    { ']b', '<cmd>BufferLineCycleNext<cr>', desc = '󰐃 Next Buffer' },
    { '[B', '<cmd>BufferLineMovePrev<cr>', desc = '󰐃 Move Buffer Prev' },
    { ']B', '<cmd>BufferLineMoveNext<cr>', desc = '󰐃 Move Buffer Next' },
  },
  config = function()
    require('bufferline').setup {
      options = {
        -- Close command integration
        close_command = 'bdelete! %d',
        right_mouse_command = 'bdelete! %d',
        left_mouse_command = 'buffer %d',
        middle_mouse_command = nil,

        -- Visual style
        indicator = {
          icon = '▎', -- This should be '▎'
          style = 'icon',
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',

        -- Tab style and sizing
        max_name_length = 30,
        max_prefix_length = 30,
        truncate_names = true,
        tab_size = 21,
        separator_style = 'slant', -- Looks modern with TokyoNight

        -- Features
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match 'error' and ' ' or ' '
          return ' ' .. icon .. count
        end,

        -- Buffer organization
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        move_wraps_at_ends = false,

        -- Offset configuration for sidebars
        offsets = {
          {
            filetype = 'neo-tree',
            text = '󰙅 File Explorer',
            text_align = 'left',
            separator = true,
          },
          {
            filetype = 'undotree',
            text = '󰕌 Undo Tree',
            text_align = 'left',
            separator = true,
          },
        },

        -- Color and theme integration
        color_icons = true,
        get_element_icon = function(element)
          local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
          return icon, hl
        end,

        -- Buffer sorting
        sort_by = 'insert_after_current',

        -- Custom filter to hide certain filetypes
        custom_filter = function(buf_number, buf_numbers)
          -- Filter out by buffer name
          if vim.fn.bufname(buf_number) ~= '' then
            if vim.fn.bufname(buf_number):match 'NvimTree' then
              return false
            end
          end
          -- Filter out by filetype
          if vim.bo[buf_number].filetype == 'qf' then
            return false
          end
          return true
        end,

        -- Hover functionality
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
      },

      -- Highlights for TokyoNight integration
      highlights = require('bufferline').highlights or {},
    }

    -- Apply TokyoNight highlights when colorscheme loads
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'tokyonight*',
      callback = function()
        local colors = require('tokyonight.colors').setup()

        -- Custom bufferline highlights for TokyoNight
        vim.api.nvim_set_hl(0, 'BufferLineIndicatorSelected', {
          fg = colors.blue,
          bg = colors.bg,
        })
        vim.api.nvim_set_hl(0, 'BufferLineFill', {
          bg = colors.bg_statusline,
        })
        vim.api.nvim_set_hl(0, 'BufferLineBufferSelected', {
          fg = colors.fg,
          bg = colors.bg,
          bold = true,
          italic = false,
        })
        vim.api.nvim_set_hl(0, 'BufferLineTabSelected', {
          fg = colors.blue,
          bg = colors.bg,
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'BufferLineSeparator', {
          fg = colors.bg_statusline,
          bg = colors.bg_statusline,
        })
        vim.api.nvim_set_hl(0, 'BufferLineSeparatorSelected', {
          fg = colors.bg_statusline,
          bg = colors.bg,
        })
        -- Diagnostic colors
        vim.api.nvim_set_hl(0, 'BufferLineError', {
          fg = colors.red1,
          bg = colors.bg_statusline,
        })
        vim.api.nvim_set_hl(0, 'BufferLineErrorSelected', {
          fg = colors.red1,
          bg = colors.bg,
        })
        vim.api.nvim_set_hl(0, 'BufferLineWarning', {
          fg = colors.yellow,
          bg = colors.bg_statusline,
        })
        vim.api.nvim_set_hl(0, 'BufferLineWarningSelected', {
          fg = colors.yellow,
          bg = colors.bg,
        })
      end,
    })

    -- Apply highlights immediately if TokyoNight is loaded
    if vim.g.colors_name and vim.g.colors_name:match 'tokyonight' then
      vim.cmd('doautocmd ColorScheme ' .. vim.g.colors_name)
    end

    -- Auto-close empty unnamed buffers
    vim.api.nvim_create_autocmd('BufDelete', {
      callback = function()
        local buffers = vim.fn.getbufinfo { buflisted = 1 }
        if #buffers == 1 and buffers[1].name == '' and not buffers[1].changed then
          vim.cmd 'enew'
        end
      end,
    })
  end,
}

