-- Neogit: Modern Git Interface for Neovim
-- - Visual git interface with staging, committing, and branch management
-- - Integrates seamlessly with Telescope and existing git workflow
-- - Modern UI that complements Oil.nvim and TokyoNight theme
-- - Enhanced diff views and interactive git operations

return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for neogit
    'sindrets/diffview.nvim', -- Enhanced diff views
    'nvim-telescope/telescope.nvim', -- Already in your config
  },

  -- Load on git-related commands or keybindings
  cmd = 'Neogit',
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = '[G]it Neo[g]it Status' },
    { '<leader>gG', '<cmd>Neogit kind=floating<cr>', desc = '[G]it Neo[G]it Float' },
    { '<leader>gc', '<cmd>Neogit commit<cr>', desc = '[G]it [C]ommit' },
    { '<leader>gp', '<cmd>Neogit push<cr>', desc = '[G]it [P]ush' },
    { '<leader>gP', '<cmd>Neogit pull<cr>', desc = '[G]it [P]ull' },
  },

  config = function()
    local neogit = require 'neogit'

    neogit.setup {
      -- Neogit behavior and UI
      auto_refresh = true,
      auto_show_console = true,
      remember_settings = false,
      use_per_project_settings = true,

      -- Enhanced console and notifications
      console_timeout = 2000,
      auto_close_console = true,

      -- Git configuration
      disable_hint = false,
      disable_context_highlighting = false,
      disable_signs = false,

      -- Telescope integration
      telescope_sorter = function()
        return require('telescope').extensions.fzf.native_fzf_sorter()
      end,

      -- Enhanced UI settings for TokyoNight integration
      kind = 'tab', -- Default to tab, but floating available via keybind

      -- TokyoNight-compatible graph settings
      graph_style = 'unicode', -- Use unicode characters for better visual appeal

      -- Status buffer configuration
      status = {
        recent_commit_count = 10,
        HEAD_padding = 10,
        mode_padding = 3,
        mode_text = {
          M = 'modified',
          N = 'new file',
          A = 'added',
          D = 'deleted',
          C = 'copied',
          U = 'updated',
          R = 'renamed',
          DD = 'unmerged',
          AU = 'unmerged',
          UD = 'unmerged',
          UA = 'unmerged',
          DU = 'unmerged',
          AA = 'unmerged',
          UU = 'unmerged',
        },
      },

      -- Commit buffer configuration
      commit_editor = {
        kind = 'auto', -- Use auto-detected editor behavior
        show_staged_diff = true,
        staged_diff_split_kind = 'split_above',
        spell_check = true,
      },

      -- Enhanced commit popup
      commit_select_view = {
        kind = 'tab',
      },

      -- Commit view configuration
      commit_view = {
        kind = 'vsplit',
        verify_commit = vim.fn.executable 'gpg' == 1, -- Enable if GPG available
      },

      -- Log view configuration
      log_view = {
        kind = 'tab',
      },

      -- Rebase editor
      rebase_editor = {
        kind = 'auto',
      },

      -- Reflog view
      reflog_view = {
        kind = 'tab',
      },

      -- Merge editor
      merge_editor = {
        kind = 'auto',
      },

      -- Tag editor
      tag_editor = {
        kind = 'auto',
      },

      -- Preview buffer configuration
      preview_buffer = {
        kind = 'split',
      },

      -- Popup configuration
      popup = {
        kind = 'split',
      },

      -- Enhanced signs for git status (TokyoNight compatible)
      signs = {
        hunk = { '', '' },
        item = { '', '' },
        section = { '', '' },
      },

      -- Integrations
      integrations = {
        telescope = true,
        diffview = true,
      },

      -- Advanced sections configuration
      sections = {
        -- Customize which sections are shown
        sequencer = {
          folded = false,
          hidden = false,
        },
        untracked = {
          folded = false,
          hidden = false,
        },
        unstaged = {
          folded = false,
          hidden = false,
        },
        staged = {
          folded = false,
          hidden = false,
        },
        stashes = {
          folded = true,
          hidden = false,
        },
        unpulled_upstream = {
          folded = true,
          hidden = false,
        },
        unmerged_upstream = {
          folded = false,
          hidden = false,
        },
        unpulled_pushRemote = {
          folded = true,
          hidden = false,
        },
        unmerged_pushRemote = {
          folded = false,
          hidden = false,
        },
        recent = {
          folded = true,
          hidden = false,
        },
        rebase = {
          folded = true,
          hidden = false,
        },
      },

      -- Custom mappings for better workflow
      mappings = {
        commit_editor = {
          ['q'] = 'Close',
          ['<C-c><C-c>'] = 'Submit',
          ['<C-c><C-k>'] = 'Abort',
        },
        commit_editor_I = {
          ['<C-c><C-c>'] = 'Submit',
          ['<C-c><C-k>'] = 'Abort',
        },
        rebase_editor = {
          ['p'] = 'Pick',
          ['r'] = 'Reword',
          ['e'] = 'Edit',
          ['s'] = 'Squash',
          ['f'] = 'Fixup',
          ['x'] = 'Execute',
          ['d'] = 'Drop',
          ['b'] = 'Break',
          ['q'] = 'Close',
          ['<C-c><C-c>'] = 'Submit',
          ['<C-c><C-k>'] = 'Abort',
          ['[c'] = 'OpenOrScrollUp',
          [']c'] = 'OpenOrScrollDown',
        },
        rebase_editor_I = {
          ['<C-c><C-c>'] = 'Submit',
          ['<C-c><C-k>'] = 'Abort',
        },
        finder = {
          ['<C-j>'] = 'Next',
          ['<C-k>'] = 'Previous',
          ['<cr>'] = 'Select',
          ['<esc>'] = 'Close',
          -- Removed invalid finder commands: Split, VSplit, Tabnew
          -- These are only available in status mappings, not finder
        },
        popup = {
          ['?'] = 'HelpPopup',
          ['A'] = 'CherryPickPopup',
          ['D'] = 'DiffPopup',
          ['M'] = 'RemotePopup',
          ['P'] = 'PushPopup',
          ['X'] = 'ResetPopup',
          ['Z'] = 'StashPopup',
          ['b'] = 'BranchPopup',
          ['B'] = 'BisectPopup',
          ['c'] = 'CommitPopup',
          ['f'] = 'FetchPopup',
          ['l'] = 'LogPopup',
          ['m'] = 'MergePopup',
          ['p'] = 'PullPopup',
          ['r'] = 'RebasePopup',
          ['t'] = 'TagPopup',
          ['w'] = 'WorktreePopup',
          ['x'] = 'RevertPopup',
        },
        status = {
          ['k'] = 'MoveUp',
          ['j'] = 'MoveDown',
          ['q'] = 'Close',
          ['o'] = 'OpenTree',
          ['I'] = 'InitRepo',
          ['1'] = 'Depth1',
          ['2'] = 'Depth2',
          ['3'] = 'Depth3',
          ['4'] = 'Depth4',
          ['<tab>'] = 'Toggle',
          ['x'] = 'Discard',
          ['s'] = 'Stage',
          ['S'] = 'StageUnstaged',
          ['<C-a>'] = 'StageAll',
          ['K'] = 'Untrack',
          ['u'] = 'Unstage',
          ['U'] = 'UnstageStaged',
          ['$'] = 'CommandHistory',
          ['Y'] = 'YankSelected',
          ['<C-r>'] = 'RefreshBuffer',
          ['<enter>'] = 'GoToFile',
          ['<C-v>'] = 'VSplitOpen',
          ['<C-x>'] = 'SplitOpen',
          ['<C-t>'] = 'TabOpen',
          ['{'] = 'GoToPreviousHunkHeader',
          ['}'] = 'GoToNextHunkHeader',
          ['[c'] = 'OpenOrScrollUp',
          [']c'] = 'OpenOrScrollDown',
        },
      },
    }

    -- Apply TokyoNight-compatible highlights after setup
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'tokyonight*',
      callback = function()
        local colors = require('tokyonight.colors').setup()

        -- Neogit buffer highlights
        vim.api.nvim_set_hl(0, 'NeogitBranch', { fg = colors.purple })
        vim.api.nvim_set_hl(0, 'NeogitRemote', { fg = colors.orange })
        vim.api.nvim_set_hl(0, 'NeogitHunkHeader', { fg = colors.blue, bold = true })
        vim.api.nvim_set_hl(0, 'NeogitHunkHeaderHighlight', { fg = colors.bg, bg = colors.blue })
        vim.api.nvim_set_hl(0, 'NeogitDiffContext', { fg = colors.fg_dark })
        vim.api.nvim_set_hl(0, 'NeogitDiffAdd', { fg = colors.green })
        vim.api.nvim_set_hl(0, 'NeogitDiffDelete', { fg = colors.red })
        vim.api.nvim_set_hl(0, 'NeogitDiffAddHighlight', { fg = colors.bg, bg = colors.green })
        vim.api.nvim_set_hl(0, 'NeogitDiffDeleteHighlight', { fg = colors.bg, bg = colors.red })
        vim.api.nvim_set_hl(0, 'NeogitCommitViewHeader', { fg = colors.cyan, bold = true })
        vim.api.nvim_set_hl(0, 'NeogitFilePath', { fg = colors.blue1 })
        vim.api.nvim_set_hl(0, 'NeogitObjectId', { fg = colors.comment })
        vim.api.nvim_set_hl(0, 'NeogitStash', { fg = colors.magenta })
        vim.api.nvim_set_hl(0, 'NeogitRebaseDone', { fg = colors.comment })
        vim.api.nvim_set_hl(0, 'NeogitFold', { fg = colors.comment })
        vim.api.nvim_set_hl(0, 'NeogitChangeModified', { fg = colors.orange })
        vim.api.nvim_set_hl(0, 'NeogitChangeAdded', { fg = colors.green })
        vim.api.nvim_set_hl(0, 'NeogitChangeDeleted', { fg = colors.red })
        vim.api.nvim_set_hl(0, 'NeogitChangeRenamed', { fg = colors.purple })
        vim.api.nvim_set_hl(0, 'NeogitChangeUpdated', { fg = colors.yellow })
        vim.api.nvim_set_hl(0, 'NeogitChangeCopied', { fg = colors.cyan })
        vim.api.nvim_set_hl(0, 'NeogitChangeUnmerged', { fg = colors.red1, bold = true })
        vim.api.nvim_set_hl(0, 'NeogitSectionHeader', { fg = colors.cyan, bold = true })
        vim.api.nvim_set_hl(0, 'NeogitUntrackedfiles', { fg = colors.red })
        vim.api.nvim_set_hl(0, 'NeogitUnstagedchanges', { fg = colors.yellow })
        vim.api.nvim_set_hl(0, 'NeogitStagedchanges', { fg = colors.green })
        vim.api.nvim_set_hl(0, 'NeogitUnpulledchanges', { fg = colors.purple })
        vim.api.nvim_set_hl(0, 'NeogitUnpushedchanges', { fg = colors.orange })
        vim.api.nvim_set_hl(0, 'NeogitRecentcommits', { fg = colors.blue })
        vim.api.nvim_set_hl(0, 'NeogitStashes', { fg = colors.magenta })
      end,
    })

    -- Apply highlights immediately if TokyoNight is already loaded
    if vim.g.colors_name and vim.g.colors_name:match 'tokyonight' then
      vim.cmd('doautocmd ColorScheme ' .. vim.g.colors_name)
    end
  end,
}
