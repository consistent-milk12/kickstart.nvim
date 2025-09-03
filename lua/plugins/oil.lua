-- lua/plugins/oil.lua
return {
  -- Core file explorer
  'stevearc/oil.nvim',

  -- Oil should not be lazy-loaded (per upstream guidance)
  lazy = false,

  -- Recommended icon provider (works great with tokyonight-night)
  dependencies = {
    { 'echasnovski/mini.icons', opts = {} },

    -- Git decorations directly inside Oil (colors + symbols)
    { 'benomahony/oil-git.nvim', dependencies = { 'stevearc/oil.nvim' } },

    -- Show LSP diagnostics in Oil buffers
    { 'JezerM/oil-lsp-diagnostics.nvim', dependencies = { 'stevearc/oil.nvim' } },
  },

  -- Top-level keys to open Oil from anywhere
  keys = {
    -- Open parent directory of current file (vinegar-style)
    { '-', '<cmd>Oil<cr>', desc = 'Oil: open parent directory' },

    -- Open Oil rooted at project/git root in a floating window
    {
      '<leader>fe',
      function()
        local cwd = vim.loop.cwd() or vim.fn.getcwd(0, 0)
        local git_root = vim.fs.find('.git', {
          upward = true,
          type = 'directory',
          path = vim.api.nvim_buf_get_name(0) ~= '' and vim.fs.dirname(vim.api.nvim_buf_get_name(0)) or cwd,
        })[1]
        local root = git_root and vim.fs.dirname(git_root) or cwd
        require('oil').open_float(root)
      end,
      desc = 'Oil: float at project root',
    },

    -- Open Oil at current buffer’s directory in a floating window
    {
      '<leader>fE',
      function()
        local cur = vim.api.nvim_buf_get_name(0)
        local dir = (cur ~= '' and vim.fs.dirname(cur)) or (vim.loop.cwd() or vim.fn.getcwd())
        require('oil').open_float(dir)
      end,
      desc = 'Oil: float here',
    },

    -- Quick toggle: reopen last Oil buffer as float
    {
      '<leader>o',
      function()
        require('oil').toggle_float()
      end,
      desc = 'Oil: toggle float',
    },
  },

  -- Plugin configuration
  config = function()
    -- Detect a trash command for safe deletes
    local has_trash = (vim.fn.executable 'trash-put' == 1) or (vim.fn.executable 'trash' == 1) or (vim.fn.executable 'gio' == 1)

    -- Detail-columns toggle state
    local DETAILS_ON = false

    -- Helper to toggle detailed columns (size/mtime/perm)
    local function toggle_details()
      DETAILS_ON = not DETAILS_ON
      if DETAILS_ON then
        require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
      else
        require('oil').set_columns { 'icon' }
      end
    end

    -- Helper to copy absolute/relative paths
    local function copy_path(opts)
      -- Use Oil action to set path into the unnamed register
      require('oil.actions').copy_entry_path.callback()
      local copied = vim.fn.getreg(vim.v.register) -- what Oil just set
      if opts and opts.relative then
        -- local base = vim.loop.cwd() or vim.fn.getcwd() -- unused
        local rel = vim.fn.fnamemodify(copied, ':.') -- relative to cwd
        -- If cwd-based relative looks same, try project root
        if rel == copied then
          local git = vim.fs.find('.git', { upward = true, type = 'directory' })[1]
          if git then
            local root = vim.fs.dirname(git)
            rel = copied:gsub('^' .. vim.pesc(root) .. '/?', '')
          end
        end
        copied = rel
      end
      -- Always mirror to system clipboard
      vim.fn.setreg('+', copied)
      vim.notify(('Path copied: %s'):format(copied), vim.log.levels.INFO, { title = 'Oil' })
    end

    -- SSH opener: prompt for ssh url (e.g. user@host:/path) and open as float
    local function open_ssh()
      local target = vim.fn.input 'SSH target (user@host:/path): '
      if target and #target > 0 then
        -- Oil’s ssh adapter understands plain scp-like paths
        require('oil').open_float(target)
      end
    end

    require('oil').setup {
      -- Make Oil own directory buffers and behave like a first-class explorer
      default_file_explorer = true,

      -- Minimal column set by default; toggle_details() adds more on demand
      columns = { 'icon' },

      -- Keep Oil buffers out of buffer lists; behave like a dedicated view
      buf_options = {
        buflisted = false,
        bufhidden = 'hide',
      },

      -- Window options tuned for a clean UI; signcolumn set for git/diag
      win_options = {
        wrap = false,
        signcolumn = 'yes:2', -- space for git + diagnostics symbols
        cursorcolumn = false,
        foldcolumn = '0',
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = 'nvic',
      },

      -- Safer deletes to desktop trash if available
      delete_to_trash = has_trash,

      -- Reduce prompts for simple edits (rename/move within a dir)
      skip_confirm_for_simple_edits = true,

      -- Prompt to save external changes before following a selection
      prompt_save_on_select_new_entry = true,

      -- Clean up hidden Oil buffers automatically
      cleanup_delay_ms = 2000,

      -- LSP-aware file ops (rename/move) with safe autosave
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = 'unmodified',
      },

      -- Keep cursor constrained to editable area (file names)
      constrain_cursor = 'editable',

      -- Auto-reload when filesystem changes (fast on Linux)
      watch_for_changes = true,

      -- Rich, ergonomic keymaps inside Oil buffers
      use_default_keymaps = false,
      keymaps = {
        -- Help for Oil buffer mappings
        ['g?'] = { 'actions.show_help', mode = 'n' },

        -- Open/select
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },

        -- Preview current entry (fast scratch buffer)
        ['<C-p>'] = 'actions.preview',

        -- Close Oil
        ['q'] = { 'actions.close', mode = 'n' },

        -- Refresh listing
        ['r'] = 'actions.refresh',

        -- Up one directory / open cwd / cd
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },

        -- Sorting / hidden / trash toggles
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },

        -- Open current entry using the OS (Kitty + Linux → xdg-open)
        ['gx'] = 'actions.open_external',

        -- Toggle detail columns (icon ↔ icon+perm+size+mtime)
        ['gd'] = {
          desc = 'Toggle detailed columns',
          callback = toggle_details,
        },

        -- Copy absolute path to + register and unnamed register
        ['yp'] = {
          desc = 'Copy absolute path',
          callback = function()
            copy_path { relative = false }
          end,
        },

        -- Copy project-relative path (git root or cwd fallback)
        ['yP'] = {
          desc = 'Copy project-relative path',
          callback = function()
            copy_path { relative = true }
          end,
        },

        -- Quick SSH: open remote dir as an Oil float
        ['gsS'] = {
          desc = 'Open SSH target (float)',
          callback = open_ssh,
        },
      },

      -- Natural human sorting, case-sensitive names, type then name
      view_options = {
        show_hidden = false,
        natural_order = 'fast',
        case_insensitive = false,
        sort = { { 'type', 'asc' }, { 'name', 'asc' } },
      },

      -- Floating window settings (polished for tokyonight-night/Kitty)
      float = {
        padding = 2,
        max_width = 0, -- 0 → auto (use screen)
        max_height = 0, -- 0 → auto
        border = 'rounded',
        win_options = { winblend = 0 },
        preview_split = 'auto',
        override = function(conf)
          return conf
        end,
      },

      -- Preview window behavior (fast, auto-updating)
      preview_win = {
        update_on_cursor_moved = true,
        preview_method = 'fast_scratch',
        disable_preview = function(_)
          return false
        end,
        win_options = { number = false, relativenumber = false },
      },

      -- SSH adapter extras (tweak scp flags if needed)
      extra_scp_args = {},

      -- Experimental git-assisted file ops: keep off by default
      git = {
        add = function(_)
          return false
        end,
        mv = function(_, _)
          return false
        end,
        rm = function(_)
          return false
        end,
      },
    }

    -- Initialize third-party extensions
    pcall(require, 'oil-git') -- benomahony/oil-git.nvim
    local ok, oil_lsp_diag = pcall(require, 'oil-lsp-diagnostics')
    if ok then
      oil_lsp_diag.setup {}
    end
  end,
}
