-- Enhanced Blink.cmp configuration for Neovim 0.12
-- Optimized for TokyoNight with Rust fuzzy matcher, ghost text, cmdline integration
return {
  'saghen/blink.cmp',
  -- Load on completion events and cmdline usage
  event = { 'InsertEnter', 'CmdlineEnter' },
  version = '1.*',
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      opts = {},
    },
    
    -- VSCode-style snippets (now enabled)
    { 'rafamadriz/friendly-snippets' },
    
    -- Lua development integration
    'folke/lazydev.nvim',
  },
  
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    -- Enable completion in most buffers, respect per-buffer toggle
    enabled = function()
      return vim.bo.buftype ~= 'prompt' and vim.b.completion ~= false
    end,

    appearance = {
      nerd_font_variant = 'mono',
    },

    -- Enhanced completion behavior
    completion = {
      -- Match on both sides of cursor for better filtering
      keyword = { range = 'full' },

      -- Smart selection behavior
      list = {
        selection = {
          preselect = function()
            return not require('blink.cmp').snippet_active({ direction = 1 })
          end,
          auto_insert = true,
        },
      },

      -- Show menu on demand, cleaner while typing
      menu = {
        auto_show = false,
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind' },
          },
        },
      },

      -- Documentation on demand
      documentation = { auto_show = false, auto_show_delay_ms = 500 },

      -- Ghost text for inline preview
      ghost_text = { enabled = true, show_with_menu = false },
    },

    -- Rust fuzzy matcher with fallback (auto-downloads prebuilt binaries)
    fuzzy = {
      implementation = 'prefer_rust_with_warning',
      sorts = { 'score', 'sort_text', 'label' },
    },

    -- Enhanced source configuration
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      per_filetype = {
        lua = { inherit_defaults = true, 'lazydev' },
      },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    snippets = { preset = 'luasnip' },

    -- Enhanced signature help
    signature = {
      enabled = true,
      window = { show_documentation = false },
    },

    -- Enhanced keymaps with power user features
    keymap = {
      preset = 'default',

      -- Quick snippet-only completion
      ['<C-s>'] = {
        function(cmp) cmp.show({ providers = { 'snippets' } }) end,
      },

      -- Ghost text navigation when menu is closed
      ['<M-n>'] = { function(cmp) cmp.select_next({ on_ghost_text = true }) end, 'fallback' },
      ['<M-p>'] = { function(cmp) cmp.select_prev({ on_ghost_text = true }) end, 'fallback' },
    },

    -- Cmdline integration (works great with noice.nvim)
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = {
        ghost_text = { enabled = true },
        menu = {
          auto_show = function(ctx)
            return vim.fn.getcmdtype() == ':'
          end,
        },
      },
    },
  },

  -- Completion toggle functionality
  keys = {
    {
      '<leader>tc',
      function()
        local cmp = require 'blink.cmp'
        cmp.hide()
        vim.b.completion = not vim.b.completion
        local state = vim.b.completion ~= false
        vim.notify(('Completion: %s'):format(state and 'ON' or 'OFF'))
      end,
      desc = '[T]oggle [C]ompletion (buffer)',
      mode = { 'n', 'i' },
    },
  },
}