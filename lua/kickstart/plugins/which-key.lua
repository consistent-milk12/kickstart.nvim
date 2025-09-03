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
      
      -- Window operations (moved from <leader>s* to avoid search conflict)
      { '<leader>w', group = ' Windows', icon = '' },
      { '<leader>wh', desc = 'Horizontal Split' },
      { '<leader>wv', desc = 'Vertical Split' },
      { '<leader>wc', desc = 'Close' },
      { '<leader>wo', desc = 'Only This' },
      { '<leader>we', desc = 'Equalize' },
      
      -- Undotree
      { '<leader>u', desc = '󰕌 Undo Tree', icon = '󰕌' },
      
      -- Navigation clusters
      { ']', group = ' Next' },
      { ']c', desc = 'Git Hunk' },
      { ']C', desc = 'Last Git Hunk' },
      { ']m', desc = 'Function' },
      { ']M', desc = 'Function End' },
      { ']k', desc = 'Class' },
      { ']K', desc = 'Class End' },
      { ']a', desc = 'Parameter' },
      
      { '[', group = ' Previous' },
      { '[c', desc = 'Git Hunk' },
      { '[C', desc = 'First Git Hunk' },
      { '[m', desc = 'Function' },
      { '[M', desc = 'Function End' },
      { '[k', desc = 'Class' },
      { '[K', desc = 'Class End' },
      { '[a', desc = 'Parameter' },
      
      -- LSP operations (integrated with enhanced g group above)
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
      
      -- Enhanced g operations (LSP + Treesitter + Flash)
      { 'g', group = ' Goto & Actions' },
      { 'g>', desc = 'Swap Next Parameter' },
      { 'g<', desc = 'Swap Prev Parameter' },
      
      -- Flash.nvim navigation
      { 's', desc = '⚡ Flash Jump', mode = { 'n', 'x', 'o' } },
      { 'S', desc = '⚡ Flash Treesitter', mode = { 'n', 'x', 'o' } },
      { 'r', desc = '⚡ Flash Remote', mode = 'o' },
      { 'R', desc = '⚡ Flash TS Search', mode = { 'o', 'x' } },
      
      -- Treesitter incremental selection
      { '<C-Space>', desc = 'TS: Init/Expand Selection', mode = { 'n', 'v' } },
      { '<C-s>', desc = 'TS: Expand Scope', mode = { 'v' } },
      { '<BS>', desc = 'TS: Shrink Selection', mode = { 'v' } },
      
      -- Treesitter text objects (visual/operator-pending)
      { 'a', group = ' Around Text Objects', mode = { 'v', 'o' } },
      { 'af', desc = 'Function', mode = { 'v', 'o' } },
      { 'ac', desc = 'Class', mode = { 'v', 'o' } },
      { 'aa', desc = 'Parameter', mode = { 'v', 'o' } },
      { 'al', desc = 'Loop', mode = { 'v', 'o' } },
      { 'ai', desc = 'Conditional', mode = { 'v', 'o' } },
      
      { 'i', group = ' Inside Text Objects', mode = { 'v', 'o' } },
      { 'if', desc = 'Function', mode = { 'v', 'o' } },
      { 'ic', desc = 'Class', mode = { 'v', 'o' } },
      { 'ia', desc = 'Parameter', mode = { 'v', 'o' } },
      { 'il', desc = 'Loop', mode = { 'v', 'o' } },
      { 'ii', desc = 'Conditional', mode = { 'v', 'o' } },
      
      -- Flash.nvim search integration (command mode)
      { '<A-f>', desc = '⚡ Toggle Flash in Search', mode = 'c' },
      
      -- Noice.nvim UI enhancements  
      { '<leader>n', group = ' Noice', icon = '' },
      { '<leader>nl', desc = 'Last Message' },
      { '<leader>nh', desc = 'Message History' },
      { '<leader>nd', desc = 'Dismiss All' },
      { '<leader>ns', desc = 'Search Messages' },
      
      -- Enhanced cmdline (command mode)
      { '<S-Enter>', desc = ' Redirect to Split', mode = 'c' },
      
      -- Language-aware code operations (Rust/Python/Lua + advanced formatting)
      { '<leader>c', group = ' Code', icon = '' },
      { '<leader>cf', desc = 'Format Buffer/Selection', mode = { 'n', 'x' } },
      { '<leader>cr', desc = 'Run (language-aware)' },
      { '<leader>ct', desc = 'Test (language-aware)' },
      { '<leader>cF', desc = 'Toggle Format-on-save' },
      { '<leader>cI', desc = 'Conform Info' },
      
      -- Enhanced quickfix workflow (Quicker.nvim)
      { '<leader>q', group = ' Quickfix', icon = '' },
      { '<leader>qq', desc = 'Toggle Quickfix' },
      { '<leader>ql', desc = 'Toggle Location List' },
      
      -- Trouble.nvim diagnostics and navigation
      { '<leader>x', group = ' Trouble', icon = '' },
      { '<leader>xx', desc = 'Diagnostics' },
      { '<leader>xX', desc = 'Buffer Diagnostics' },
      { '<leader>xs', desc = 'Symbols' },
      { '<leader>xl', desc = 'LSP References' },
      { '<leader>xL', desc = 'Location List' },
      { '<leader>xQ', desc = 'Quickfix List' },
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