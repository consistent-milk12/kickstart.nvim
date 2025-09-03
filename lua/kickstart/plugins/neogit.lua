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

      -- Enhanced signs for git status
      signs = {
        hunk = { '', '' },
        item = { '>', ' ' },
        section = { '>', 'v' },
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
          ['<C-x>'] = 'Split',
          ['<C-v>'] = 'VSplit',
          ['<C-t>'] = 'Tabnew',
          ['<cr>'] = 'Select',
          ['<esc>'] = 'Close',
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
          ['<C-s>'] = 'StageAll',
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
  end,
}

