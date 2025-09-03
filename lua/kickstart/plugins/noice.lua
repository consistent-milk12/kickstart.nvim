-- Noice.nvim: Enhanced UI for messages, cmdline, and popupmenu
-- Integrates with TokyoNight Night theme and existing notification workflow

return {
  -- UI for messages, cmdline, popupmenu
  'folke/noice.nvim',

  -- Load earlier to catch LSP functions
  event = { 'VeryLazy', 'LspAttach' },

  -- Required & recommended deps
  dependencies = {
    -- UI components used by noice
    'MunifTanjim/nui.nvim',
    -- Notification backend used by noice
    'rcarriga/nvim-notify',
    -- Optional: Telescope picker for message history
    'nvim-telescope/telescope.nvim',
  },

  -- Handy keymaps
  keys = {
    -- View last message
    { '<leader>nl', '<cmd>Noice last<cr>', desc = '[N]oice: [L]ast message' },
    -- View message history
    { '<leader>nh', '<cmd>Noice history<cr>', desc = '[N]oice: [H]istory' },
    -- Dismiss all messages/notifications
    {
      '<leader>nd',
      function()
        -- Use notify's dismiss if present; fall back to Noice
        local ok, notify = pcall(require, 'notify')
        if ok and notify then
          notify.dismiss { silent = true, pending = true }
        end
        pcall(vim.cmd, 'Noice dismiss')
      end,
      desc = '[N]oice: [D]ismiss all',
    },
    -- Telescope over messages (if extension is loaded)
    { '<leader>ns', '<cmd>Telescope noice<cr>', desc = '[N]oice: [S]earch messages' },
    -- Redirect current cmdline to a split (great for long :%s or :lua)
    {
      '<S-Enter>',
      function()
        require('noice').redirect(vim.fn.getcmdline())
      end,
      mode = 'c',
      desc = 'Noice: redirect cmdline to split',
    },
  },

  -- Options wrapped in a function so we can compute values
  opts = function()
    -- Compact notifications that suit tokyonight and Kitty
    local notify_opts = {
      -- Smooth animation preset
      stages = 'fade_in_slide_out',
      -- Dense layout
      render = 'compact',
      -- Show newest at the bottom-right
      top_down = false,
      -- Reasonable default
      timeout = 4000,
      -- Blend with theme background (fallback if scheme lacks a color)
      background_colour = '#000000',
    }

    -- Unified filters for hiding noisy msgs
    local hide_search_hit = {
      event = 'msg_show',
      any = {
        { find = 'search hit BOTTOM' },
        { find = 'search hit TOP' },
      },
    }
    local mini_writes = {
      event = 'msg_show',
      any = {
        { find = '%d+ lines? yanked' },
        { find = '%d+ lines? changed' },
        { find = '%d+ lines? (written|added|fewer|more)' },
        { find = 'Already at newest change' },
        { kind = '', find = 'written' },
      },
    }

    return {
      -- Replace vim.notify with nvim-notify and route messages
      notify = {
        -- Enable Noice's notify integration
        enabled = true,
        -- Use the "notify" view for most output
        view = 'notify',
      },

      -- Core message UI
      messages = {
        enabled = true,
        -- Errors & warnings to notify; history to split
        view_error = 'notify',
        view_warn = 'notify',
        view_history = 'split',
        -- Show search count via virtual text in-buffer
        view_search = 'virtualtext',
      },

      -- Cmdline UI (":" "/" "?") and popupmenu
      cmdline = {
        enabled = true,
        -- Popup cmdline centered (pairs nicely with Telescope/Flash)
        view = 'cmdline_popup',
        -- Icons + language hints for common modes
        format = {
          cmdline = { pattern = '^:', icon = ':', lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = '/' },
          search_up = { kind = 'search', pattern = '^%?', icon = '?' },
          filter = { pattern = '^:%s*!', icon = '!', lang = 'bash' },
          lua = { pattern = '^:%s*lua%s+', icon = '', lang = 'lua' },
          help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
        },
      },

      -- Popup completion menu rendered by Noice
      popupmenu = {
        enabled = true,
        backend = 'nui',
      },

      -- LSP UIs (hover, signature, progress)
      lsp = {
        -- Progress notifications with spinner
        progress = { enabled = true, throttle = 100 },
        -- Show hover/signature via Noice popups
        hover = { enabled = true },
        signature = { enabled = true, auto_open = { enabled = true } },
        -- Override markdown rendering so cmp & LSP docs use TS highlights
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
          -- Additional overrides to prevent warnings
          ['vim.lsp.util.open_floating_preview'] = true,
        },
      },

      -- Presets that change several options together
      presets = {
        -- Bottom-style search cmdline (classic Vim look)
        bottom_search = true,
        -- Align cmdline and popupmenu visually (command palette feel)
        command_palette = true,
        -- Overflowing messages go to a split
        long_message_to_split = true,
        -- Add borders to hover/signature docs
        lsp_doc_border = true,
        -- Keep inc-rename separate (you'll likely use a dedicated plugin)
        inc_rename = false,
      },

      -- Views: tune some sizes/positions
      views = {
        -- Compact mini messages
        mini = { timeout = 2500, reverse = false },
        -- Tweak the cmdline popup to avoid covering the center too much
        cmdline_popup = {
          border = { style = 'rounded' },
          position = { row = '40%', col = '50%' },
          size = { width = 60, height = 'auto' },
          win_options = { winblend = 0 },
        },
        -- Notification view delegates to nvim-notify theme
        notify = {},
      },

      -- Routes: filter or reroute specific messages
      routes = {
        -- Silence "search hit top/bottom"
        { filter = hide_search_hit, opts = { skip = true } },
        -- Demote common write/yank/etc. to a tiny view
        { filter = mini_writes, view = 'mini' },
      },
    },
      notify_opts
  end,

  -- Final wiring
  config = function(_, opts)
    -- Split opts for noice and notify
    local noice_opts, notify_opts = opts[1], opts[2]

    -- Initialize nvim-notify and override vim.notify
    local ok_notify, notify = pcall(require, 'notify')
    if ok_notify then
      notify.setup(notify_opts)
      vim.notify = notify
    end

    -- Initialize Noice with our configuration
    require('noice').setup(noice_opts)

    -- Ensure LSP functions are properly overridden to prevent warnings
    pcall(function()
      -- Force override these functions to prevent Noice warnings
      local original_convert = vim.lsp.util.convert_input_to_markdown_lines
      local original_stylize = vim.lsp.util.stylize_markdown

      vim.lsp.util.convert_input_to_markdown_lines = function(...)
        return require('noice').redirect(original_convert(...))
      end

      vim.lsp.util.stylize_markdown = function(...)
        return require('noice').redirect(original_stylize(...))
      end
    end)

    -- Load Telescope extension for Noice (if installed)
    pcall(function()
      require('telescope').load_extension 'noice'
    end)
  end,
}

