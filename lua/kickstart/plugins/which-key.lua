return { -- Enhanced which-key with comprehensive group documentation
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    -- Performance and UX settings
    delay = 200, -- Slight delay for better UX (not instant popup)
    timeout = true,
    
    -- Enhanced visual settings
    preset = 'modern',
    notify = true,
    triggers = {
      { '<auto>', mode = 'nixsotc' },
      { 's', mode = { 'n', 'v' } },
    },
    
    -- Enhanced icons and styling
    icons = {
      mappings = vim.g.have_nerd_font,
      keys = vim.g.have_nerd_font and {} or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>', F2 = '<F2>', F3 = '<F3>', F4 = '<F4>',
        F5 = '<F5>', F6 = '<F6>', F7 = '<F7>', F8 = '<F8>',
        F9 = '<F9>', F10 = '<F10>', F11 = '<F11>', F12 = '<F12>',
      },
      -- Custom icons for groups
      group = vim.g.have_nerd_font and '' or '+',
      separator = '→',
    },
    
    -- Layout and window settings
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = 'left',
    },
    
    -- Comprehensive key group documentation
    spec = {
      -- Search group (Telescope)
      { '<leader>s', group = ' Search', icon = '' },
      { '<leader>sf', desc = 'Files' },
      { '<leader>sg', desc = 'Live Grep' },
      { '<leader>sb', desc = 'Buffers' },
      { '<leader>sh', desc = 'Help Tags' },
      { '<leader>sk', desc = 'Keymaps' },
      { '<leader>sc', desc = 'Colorschemes' },
      { '<leader>sr', desc = 'Resume' },
      { '<leader>s.', desc = 'Recent Files' },
      { '<leader>su', desc = 'Undo Tree' },
      { '<leader>sn', desc = 'Neovim Config' },
      { '<leader>sd', desc = 'Diagnostics' },
      { '<leader>sl', desc = 'Document Symbols' },
      { '<leader>sL', desc = 'Workspace Symbols' },
      
      -- File management (Oil)
      { '<leader>f', group = ' Files', icon = '' },
      { '<leader>fe', desc = 'Explorer (Root)' },
      { '<leader>fE', desc = 'Explorer (Here)' },
      { '<leader>fo', desc = 'Reveal Current' },
      { '<leader>fO', desc = 'Open CWD' },
      { '<leader>fz', desc = 'Zoxide Jump' },
      
      -- Git operations (GitSigns + Telescope)
      { '<leader>h', group = ' Git Hunks', mode = { 'n', 'v' }, icon = '' },
      { '<leader>hs', desc = 'Stage Hunk' },
      { '<leader>hr', desc = 'Reset Hunk' },
      { '<leader>hS', desc = 'Stage Buffer' },
      { '<leader>hR', desc = 'Reset Buffer' },
      { '<leader>hu', desc = 'Undo Stage' },
      { '<leader>hp', desc = 'Preview Hunk' },
      { '<leader>hb', desc = 'Blame Line' },
      { '<leader>hd', desc = 'Diff Index' },
      { '<leader>hD', desc = 'Diff HEAD~1' },
      
      { '<leader>g', group = ' Git', icon = '' },
      { '<leader>gc', desc = 'Commits' },
      { '<leader>gC', desc = 'Buffer Commits' },
      { '<leader>gb', desc = 'Branches' },
      { '<leader>gs', desc = 'Status' },
      { '<leader>gS', desc = 'Stash' },
      { '<leader>gq', desc = 'Changes → Quickfix' },
      { '<leader>gl', desc = 'Changes → Loclist' },
      
      -- Toggle options
      { '<leader>t', group = '󰔡 Toggle', icon = '󰔡' },
      { '<leader>tb', desc = 'Git Blame' },
      { '<leader>ts', desc = 'Git Signs' },
      { '<leader>tD', desc = 'Git Deleted' },
      { '<leader>tn', desc = 'Number Highlight' },
      { '<leader>tl', desc = 'Line Highlight' },
      { '<leader>tw', desc = 'Word Diff' },
      
      -- Buffer operations
      { '<leader>b', group = ' Buffers', icon = '' },
      { '<leader>bd', desc = 'Delete' },
      { '<leader>bD', desc = 'Delete Others' },
      { '<leader>bn', desc = 'Next' },
      { '<leader>bp', desc = 'Previous' },
      { '<leader>bl', desc = 'List' },
      
      -- Window/Split operations
      { '<leader>s', group = ' Splits', icon = '', mode = 'n' },
      { '<leader>sh', desc = 'Horizontal' },
      { '<leader>sv', desc = 'Vertical' },
      { '<leader>sc', desc = 'Close' },
      { '<leader>so', desc = 'Only This' },
      { '<leader>se', desc = 'Equalize' },
      
      -- Undotree
      { '<leader>u', desc = '󰕌 Undo Tree', icon = '󰕌' },
      
      -- Navigation clusters
      { ']', group = ' Next' },
      { ']c', desc = 'Git Hunk' },
      { ']C', desc = 'Last Git Hunk' },
      
      { '[', group = ' Previous' },
      { '[c', desc = 'Git Hunk' },
      { '[C', desc = 'First Git Hunk' },
      
      -- LSP operations (when available)
      { 'g', group = ' Goto' },
      { 'gr', group = ' References/Rename' },
      { 'grn', desc = 'Rename' },
      { 'gra', desc = 'Code Action' },
      { 'grr', desc = 'References' },
      { 'grd', desc = 'Definition' },
      { 'gri', desc = 'Implementation' },
      { 'gO', desc = 'Document Symbols' },
      
      -- Window navigation
      { '<C-h>', desc = '← Window' },
      { '<C-j>', desc = '↓ Window' },
      { '<C-k>', desc = '↑ Window' },
      { '<C-l>', desc = '→ Window' },
      
      -- Telescope Oil integration
      { '<M-o>', desc = 'Reveal in Oil', mode = { 'n', 'i' } },
      { '<M-O>', desc = 'Open Dir in Oil', mode = { 'n', 'i' } },
    },
    
    -- Custom sorting for better organization
    sort = { 'local', 'order', 'group', 'alphanum', 'mod' },
    
    -- Enhanced expand behavior
    expand = 1, -- Expand groups by default
    
    -- Show help and count
    show_help = true,
    show_keys = true,
  },
}