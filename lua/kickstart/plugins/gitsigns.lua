-- GitSigns: Advanced Git Integration with Enhanced Features
-- - Comprehensive git gutter signs and change management
-- - Advanced hunk navigation and manipulation
-- - Blame integration with virtual text
-- - Staging and unstaging with visual feedback
-- - Integration with telescope and other git tools

return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre', -- Load when reading files for better performance
    opts = {
      -- Enhanced sign configuration
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },

      -- Sign column configuration
      signs_staged_enable = true,
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`

      -- Advanced features
      watch_gitdir = {
        enabled = true,
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = true,

      -- Current line blame configuration
      current_line_blame = false, -- Can be toggled
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 300,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

      -- Performance and behavior
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable for files longer than this

      -- Preview configuration
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },

      -- Advanced on_attach function with comprehensive keymaps
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          opts.silent = opts.silent ~= false
          vim.keymap.set(mode, l, r, opts)
        end

        -- Enhanced Navigation with count support
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk()
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk()
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- First/Last hunk navigation
        map('n', ']C', function()
          gitsigns.nav_hunk { navigation_message = false, wrap = false }
          -- Keep going to the end
          vim.schedule(function()
            while gitsigns.nav_hunk { navigation_message = false, wrap = false } do
            end
          end)
        end, { desc = 'Jump to last git [C]hange' })

        map('n', '[C', function()
          gitsigns.next_hunk { navigation_message = false, wrap = false }
          -- Keep going to the beginning
          vim.schedule(function()
            while gitsigns.prev_hunk { navigation_message = false, wrap = false } do
            end
          end)
        end, { desc = 'Jump to first git [C]hange' })

        -- Hunk Actions (Visual and Normal mode)
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git [h]unk [s]tage' })

        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git [h]unk [r]eset' })

        -- Normal mode hunk actions
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Git [h]unk [s]tage' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Git [h]unk [r]eset' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Git [h]unk [u]ndo stage' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Git [h]unk [p]review' })
        map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'Git [h]unk preview [i]nline' })

        -- Buffer-wide actions
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Git [h]unk [S]tage buffer' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Git [h]unk [R]eset buffer' })

        -- Blame functionality
        map('n', '<leader>hb', function()
          gitsigns.blame_line { full = true }
        end, { desc = 'Git [h]unk [b]lame line (full)' })

        map('n', '<leader>hB', function()
          gitsigns.blame_line { full = false }
        end, { desc = 'Git [h]unk [B]lame line (short)' })

        -- Diff functionality
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Git [h]unk [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '~1'
        end, { desc = 'Git [h]unk [D]iff against HEAD~1' })

        -- Advanced diff options
        map('n', '<leader>hda', function()
          gitsigns.diffthis 'HEAD'
        end, { desc = 'Git [h]unk [d]iff [a]gainst HEAD' })

        -- Toggle features
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
        map('n', '<leader>ts', gitsigns.toggle_signs, { desc = '[T]oggle git [s]igns' })
        map('n', '<leader>tn', gitsigns.toggle_numhl, { desc = '[T]oggle git [n]umber highlight' })
        map('n', '<leader>tl', gitsigns.toggle_linehl, { desc = '[T]oggle git [l]ine highlight' })
        map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git [w]ord diff' })

        -- Advanced git operations
        map('n', '<leader>gq', function()
          gitsigns.setqflist 'all'
        end, { desc = '[G]it changes to [q]uickfix list' })

        map('n', '<leader>gQ', function()
          gitsigns.setqflist()
        end, { desc = '[G]it buffer changes to [Q]uickfix' })

        map('n', '<leader>gl', function()
          gitsigns.setloclist 'all'
        end, { desc = '[G]it changes to [l]ocation list' })

        map('n', '<leader>gL', function()
          gitsigns.setloclist()
        end, { desc = '[G]it buffer changes to [L]ocation list' })

        -- Text object for git hunks (works with operators like d, y, etc.)
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })
        map({ 'o', 'x' }, 'ah', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })

        -- Integration with Telescope (if available)
        if pcall(require, 'telescope') then
          map('n', '<leader>gh', function()
            require('telescope.builtin').git_status()
          end, { desc = '[G]it [h]unks with Telescope' })
        end

        -- Hunk information
        map('n', '<leader>hi', function()
          local hunks = gitsigns.get_hunks(0)
          if hunks and #hunks > 0 then
            local cursor_line = vim.fn.line '.'
            local current_hunk = nil

            for _, hunk in ipairs(hunks) do
              if cursor_line >= hunk.start and cursor_line <= hunk.vend then
                current_hunk = hunk
                break
              end
            end

            if current_hunk then
              local info = string.format(
                'Hunk: +%d -%d (lines %d-%d)',
                current_hunk.added and current_hunk.added.count or 0,
                current_hunk.removed and current_hunk.removed.count or 0,
                current_hunk.start,
                current_hunk.vend
              )
              vim.notify(info, vim.log.levels.INFO, { title = 'Git Hunk Info' })
            else
              vim.notify('No hunk at cursor', vim.log.levels.WARN)
            end
          else
            vim.notify('No hunks in buffer', vim.log.levels.WARN)
          end
        end, { desc = 'Git [h]unk [i]nfo' })
      end,

      -- Trouble.nvim integration
      trouble = true,

      -- Performance optimizations
      diff_opts = {
        algorithm = 'patience',
        internal = true,
      },
    },
  },
}
