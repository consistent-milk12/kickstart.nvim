-- Snacks.nvim - Performance optimizations only, UI handled by dedicated plugins
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- Performance optimizations (no conflicts)
    bigfile = { enabled = true }, -- Large file performance
    quickfile = { enabled = true }, -- Quick file operations
    statuscolumn = { enabled = true }, -- Enhanced status column
    scope = { enabled = true }, -- Scope-based features
    
    -- Disabled - using dedicated plugins instead
    dashboard = { enabled = false }, -- Keep startup clean
    explorer = { enabled = false }, -- Using Oil.nvim
    picker = { enabled = false }, -- Using telescope.nvim
    scroll = { enabled = false }, -- Using neoscroll.nvim instead
    input = { enabled = false }, -- Conflicts with noice.nvim
    notifier = { enabled = false }, -- Conflicts with nvim-notify + noice
    words = { enabled = false }, -- Conflicts with illuminate.nvim
  },
}
