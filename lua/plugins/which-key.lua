return { -- Enhanced which-key with comprehensive documentation and visual improvements
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    -- Performance and UX settings
    delay = 150, -- Faster response for better workflow
    timeout = true,
    
    -- Enhanced visual settings with better preset
    preset = 'modern',
    notify = true,
    triggers = {
      { '<auto>', mode = 'nixsotc' },
      { 's', mode = { 'n', 'v' } }, -- Flash.nvim integration
      { 'g', mode = { 'n', 'v' } }, -- Enhanced goto operations
      { 'z', mode = 'n' }, -- Fold and scroll operations
      { ']', mode = 'n' }, -- Next operations
      { '[', mode = 'n' }, -- Previous operations
      { 'c', mode = { 'n', 'v' } }, -- Change operations with text objects
      { 'd', mode = { 'n', 'v' } }, -- Delete operations with text objects
      { 'y', mode = 'n' }, -- Yank operations with text objects (normal mode only)
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
      
      -- Toggle options & Terminal operations
      { '<leader>t', group = '󰔡 Toggle & Terminal', icon = '󰔡' },
      { '<leader>tb', desc = 'Git Blame' },
      { '<leader>ts', desc = 'Git Signs' },
      { '<leader>tD', desc = 'Git Deleted' },
      { '<leader>tn', desc = 'Number Highlight' },
      { '<leader>tl', desc = 'Line Highlight' },
      { '<leader>tw', desc = 'Word Diff' },
      { '<leader>tc', desc = 'Completion (buffer)' },
      { '<leader>th', desc = 'Inlay Hints' },
      { '<leader>tf', desc = '󰆍 Terminal Float' },
      { '<leader>tv', desc = '󰆍 Terminal Vertical' },
      { '<leader>tt', desc = '󰆍 Toggle Terminal' },
      { '<leader>tp', desc = ' Python REPL' },
      
      -- Buffer operations (enhanced with bufferline)
      { '<leader>b', group = ' Buffers', icon = '' },
      { '<leader>bd', desc = 'Delete' },
      { '<leader>bD', desc = 'Delete Others' },
      { '<leader>bn', desc = 'Next' },
      { '<leader>bp', desc = 'Previous' },
      { '<leader>bl', desc = 'List' },
      { '<leader>bP', desc = 'Toggle Pin' },
      { '<leader>br', desc = 'Close Right' },
      { '<S-h>', desc = '󰐃 Prev Buffer' },
      { '<S-l>', desc = '󰐃 Next Buffer' },
      { ']b', desc = '󰐃 Next Buffer' },
      { '[b', desc = '󰐃 Prev Buffer' },
      { ']B', desc = '󰐃 Move Buffer Next' },
      { '[B', desc = '󰐃 Move Buffer Prev' },
      
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
      
      -- Neogit keybindings (modern git interface)
      { '<leader>gg', desc = '󰊢 Neogit Status' },
      { '<leader>gG', desc = '󰊢 Neogit Float' },
      { '<leader>gp', desc = '󰊢 Git Push' },
      { '<leader>gP', desc = '󰊢 Git Pull' },
      
      -- Enhanced completion keybindings
      { '<C-s>', desc = '󰆥 Snippets Only', mode = 'i' },
      { '<M-n>', desc = '󰆤 Ghost Text Next', mode = 'i' },
      { '<M-p>', desc = '󰆣 Ghost Text Prev', mode = 'i' },
      
      -- Blink.cmp documentation and menu
      { '<C-space>', desc = '󰋖 Show Completion/Docs', mode = 'i' },
      { '<C-y>', desc = '󰄬 Accept Completion', mode = 'i' },
      { '<C-e>', desc = '󰅙 Cancel Completion', mode = 'i' },
      { '<C-k>', desc = '󰋖 Toggle Signature', mode = 'i' },
      
      -- Neoscroll smooth scrolling indicators
      { '<C-u>', desc = '󰄛 Scroll Up (smooth)' },
      { '<C-d>', desc = '󰄜 Scroll Down (smooth)' },
      { '<C-b>', desc = '󰄛 Page Up (smooth)' },
      { '<C-f>', desc = '󰄜 Page Down (smooth)' },
      { '<C-y>', desc = '󰄛 Line Up (smooth)' },
      { '<C-e>', desc = '󰄜 Line Down (smooth)' },
      { 'zt', desc = '󰞁 Top Line (smooth)' },
      { 'zz', desc = '󰞀 Center Line (smooth)' },
      { 'zb', desc = '󰞂 Bottom Line (smooth)' },
      
      -- Autopairs integration indicators
      { '<CR>', desc = '󰌑 Smart Enter/Pair', mode = 'i' },
      
      -- Surround operations (nvim-surround)
      { 'ys', desc = '󰅪 Add Surround', mode = { 'n', 'v' } },
      { 'ds', desc = '󰅟 Delete Surround' },
      { 'cs', desc = '󰛿 Change Surround' },
      
      -- Enhanced diagnostic navigation
      { ']d', desc = '󰒡 Next Diagnostic' },
      { '[d', desc = '󰒢 Prev Diagnostic' },
      { ']e', desc = '󰅚 Next Error' },
      { '[e', desc = '󰅚 Prev Error' },
      { ']w', desc = '󰀪 Next Warning' },
      { '[w', desc = '󰀪 Prev Warning' },
      
      -- Oil file management (enhanced descriptions)
      { '-', desc = '󰝰 Oil Parent Directory' },
      { '<leader>fe', desc = '󰝰 Oil Explorer (Root)' },
      { '<leader>fE', desc = '󰝰 Oil Explorer (Here)' },
      { '<leader>fo', desc = '󰝰 Reveal in Oil' },
      { '<leader>fO', desc = '󰝰 Open CWD in Oil' },
      
      -- Additional useful mappings that might be missing
      { 'gx', desc = '󰖟 Open URL/Path' },
      { 'K', desc = '󰋖 Hover Documentation' },
      { 'gK', desc = '󰋖 Signature Help' },
      
      -- Terminal mode enhancements
      { '<Esc><Esc>', desc = '󰆍 Exit Terminal', mode = 't' },
      { '<C-\\>', desc = '󰆍 Quick Terminal', mode = { 'n', 'i', 't' } },
      { '<C-h>', desc = '← Window (Terminal)', mode = 't' },
      { '<C-j>', desc = '↓ Window (Terminal)', mode = 't' },
      { '<C-k>', desc = '↑ Window (Terminal)', mode = 't' },
      { '<C-l>', desc = '→ Window (Terminal)', mode = 't' },
      
      -- Visual mode enhancements
      { '<', desc = '󰄽 Unindent & Reselect', mode = 'v' },
      { '>', desc = '󰄾 Indent & Reselect', mode = 'v' },
      { 'J', desc = '󰩷 Join Lines', mode = 'v' },
      { 'K', desc = '󰩸 Split Lines', mode = 'v' },
      
      -- Enhanced search and replace
      { '*', desc = '󰍉 Search Word Forward' },
      { '#', desc = '󰍉 Search Word Backward' },
      { 'n', desc = '󰒭 Next Search' },
      { 'N', desc = '󰒮 Prev Search' },
      
      -- Register operations
      { '"', desc = '󰅪 Register Prefix' },
      { '@', desc = '󰑭 Execute Macro' },
      { 'q', desc = '󰑬 Record Macro' },
      
      -- Fold operations
      { 'za', desc = '󰘖 Toggle Fold' },
      { 'zc', desc = '󰘕 Close Fold' },
      { 'zo', desc = '󰘗 Open Fold' },
      { 'zM', desc = '󰘕 Close All Folds' },
      { 'zR', desc = '󰘗 Open All Folds' },
      
      -- Mark operations
      { 'm', desc = '󰃃 Set Mark' },
      { "'", desc = '󰃃 Go to Mark Line' },
      { '`', desc = '󰃃 Go to Mark Position' },
      
      -- Additional text objects
      { 'ciw', desc = '󰬳 Change Inner Word' },
      { 'caw', desc = '󰬴 Change A Word' },
      { 'ci"', desc = '󰬳 Change Inner Quotes' },
      { 'ca"', desc = '󰬴 Change A Quotes' },
      { 'ci(', desc = '󰬳 Change Inner Parens' },
      { 'ca(', desc = '󰬴 Change A Parens' },
      { 'ci{', desc = '󰬳 Change Inner Braces' },
      { 'ca{', desc = '󰬴 Change A Braces' },
      { 'ci[', desc = '󰬳 Change Inner Brackets' },
      { 'ca[', desc = '󰬴 Change A Brackets' },
    },
    
    -- Enhanced sorting for intuitive organization
    sort = { 'local', 'order', 'group', 'alphanum', 'mod', 'manual' },
    
    -- Better expand behavior for discoverability
    expand = 2, -- Show more mappings by default for better learning
    
    -- Enhanced help and display options
    show_help = true,
    show_keys = true,
    
    -- Improved plugin integration
    plugins = {
      marks = true, -- Show marks in which-key
      registers = true, -- Show registers in which-key  
      spelling = {
        enabled = true, -- Show spelling suggestions
        suggestions = 20, -- Number of suggestions
      },
      presets = {
        operators = true, -- Help for operators like d, y, c
        motions = true, -- Help for motions
        text_objects = true, -- Help for text objects like a), i), etc.
        windows = true, -- Default bindings on <c-w>
        nav = true, -- Misc bindings to work with windows
        z = true, -- Bindings for folding, spelling and others prefixed with z
        g = true, -- Bindings for prefixed with g
      },
    },
    
    -- Window configuration for better readability
    win = {
      border = 'rounded', -- Matches other plugin borders
      padding = { 1, 2 }, -- Comfortable padding
      title = true,
      title_pos = 'center',
      zindex = 1000,
      -- Better colors
      wo = {
        winblend = 10, -- Slight transparency for modern look
      },
    },
    
    -- Better layout configuration
    layout = {
      width = { min = 20, max = 50 },
      height = { min = 4, max = 25 },
      spacing = 3, -- Spacing between columns
      align = 'left', -- Left align for readability
    },
  },
}