return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- Optimized for 2025 ecosystem - disabled features with dedicated plugins
    bigfile = { enabled = true }, -- Performance optimization for large files
    dashboard = { enabled = true }, -- Clean startup dashboard
    explorer = { enabled = false }, -- Using neo-tree.nvim instead
    input = { enabled = true }, -- Enhanced input UI
    picker = { enabled = false }, -- Using telescope.nvim instead
    notifier = { enabled = true }, -- Notification system
    quickfile = { enabled = true }, -- Performance for quick file operations
    scope = { enabled = true }, -- Scope-based features
    scroll = { enabled = true }, -- Smooth scrolling experience
    statuscolumn = { enabled = true }, -- Enhanced status column
    words = { enabled = true }, -- Word highlighting features
  },
}
