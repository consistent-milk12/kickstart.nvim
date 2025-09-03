-- Modern code navigation and symbol outline
return {
  'stevearc/aerial.nvim',
  
  -- Dependencies for enhanced functionality
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  
  -- Load on demand for better performance
  cmd = {
    'AerialToggle',
    'AerialOpen', 
    'AerialClose',
    'AerialNext',
    'AerialPrev',
    'AerialInfo',
  },
  
  -- Keymaps for quick access
  keys = {
    { '<leader>cs', '<cmd>AerialToggle<cr>', desc = '[C]ode [S]ymbols outline' },
    { '<leader>cS', '<cmd>AerialNavToggle<cr>', desc = '[C]ode [S]ymbols navigation' },
    { '[s', '<cmd>AerialPrev<cr>', desc = 'Previous symbol' },
    { ']s', '<cmd>AerialNext<cr>', desc = 'Next symbol' },
  },
  
  config = function()
    local aerial = require('aerial')
    
    aerial.setup({
      -- Priority of backends for symbol extraction
      backends = { 'treesitter', 'lsp', 'markdown', 'asciidoc', 'man' },
      
      -- Layout configuration
      layout = {
        -- Minimum width for the aerial window
        min_width = 25,
        -- Default width - can be integer or float (percentage)
        default_direction = 'prefer_right',
        -- Placement strategy when opening aerial
        placement = 'window',
      },
      
      -- Control when aerial automatically attaches to buffers  
      attach_mode = 'window', -- Attach to windows instead of buffers
      close_automatic_events = { 'unfocus' },
      
      -- Show line numbers in the aerial window
      show_guides = true,
      -- Customize guide characters
      guides = {
        mid_item = '├─',
        last_item = '└─',
        nested_top = '│ ',
        whitespace = '  ',
      },
      
      -- Filter symbols to display
      filter_kind = {
        'Class',
        'Constructor', 
        'Enum',
        'Function',
        'Interface',
        'Module',
        'Method',
        'Struct',
        'Type',
        'Variable',
        'Constant',
      },
      
      -- Highlight the symbol in the source buffer when cursor moves in aerial
      highlight_mode = 'split_width',
      highlight_closest = true,
      highlight_on_hover = true,
      
      -- Auto-close behavior
      close_on_select = false, -- Keep aerial open when selecting symbol
      
      -- Integration with other plugins
      -- Manage the cursor position when aerial window is opened/closed
      manage_folds = true,
      
      -- Icons configuration (uses nvim-web-devicons)
      icons = {
        -- Use nerd font icons for better visual integration
        Collapsed = '',
        Expanded = '',
      },
      
      -- Treesitter-specific configuration
      treesitter = {
        -- Update aerial when treesitter updates
        update_delay = 100,
      },
      
      -- LSP-specific configuration  
      lsp = {
        -- Refresh symbols when LSP updates
        update_when_errors = true,
        update_delay = 100,
        -- Prioritize LSP symbols over treesitter when available
        diagnostics_trigger_update = false,
      },
      
      -- Performance optimizations
      lazy_load = true,
      -- Disable for very large files (matches treesitter bigfile logic)
      disable = {
        -- Disable when file is too large
        max_lines = 25000,
        max_size = 1.5 * 1024 * 1024, -- 1.5MB
      },
      
      -- Integration with which-key for keymap documentation  
      keymaps = {
        ['?'] = 'actions.show_help',
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.jump',
        ['<2-LeftMouse>'] = 'actions.jump',
        ['<C-v>'] = 'actions.jump_vsplit',
        ['<C-s>'] = 'actions.jump_split',
        ['p'] = 'actions.scroll',
        ['<C-j>'] = 'actions.down_and_scroll',
        ['<C-k>'] = 'actions.up_and_scroll',
        ['{'] = 'actions.prev',
        ['}'] = 'actions.next',
        ['[['] = 'actions.prev_up',
        [']]'] = 'actions.next_up',
        ['q'] = 'actions.close',
        ['o'] = 'actions.tree_toggle',
        ['za'] = 'actions.tree_toggle',
        ['O'] = 'actions.tree_toggle_recursive',
        ['zA'] = 'actions.tree_toggle_recursive',
        ['l'] = 'actions.tree_open',
        ['zo'] = 'actions.tree_open',
        ['L'] = 'actions.tree_open_recursive',
        ['zO'] = 'actions.tree_open_recursive',
        ['h'] = 'actions.tree_close',
        ['zc'] = 'actions.tree_close',
        ['H'] = 'actions.tree_close_recursive',
        ['zC'] = 'actions.tree_close_recursive',
        ['zr'] = 'actions.tree_increase_fold_level',
        ['zR'] = 'actions.tree_open_all',
        ['zm'] = 'actions.tree_decrease_fold_level',
        ['zM'] = 'actions.tree_close_all',
        ['zx'] = 'actions.tree_sync_folds',
        ['zX'] = 'actions.tree_sync_folds',
      },
    })
    
    -- Auto-open aerial for supported filetypes (optional)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'rust', 'python', 'lua', 'javascript', 'typescript' },
      callback = function()
        -- Only auto-open if the buffer is substantial
        local line_count = vim.api.nvim_buf_line_count(0)
        if line_count > 100 then
          -- Delay opening to avoid startup impact
          vim.defer_fn(function()
            -- Only open if aerial would have content
            if require('aerial').num_symbols() > 0 then
              -- Uncomment the next line to auto-open aerial
              -- require('aerial').open()
            end
          end, 500)
        end
      end,
    })
    
    -- Integration with telescope for symbol searching
    local has_telescope, telescope = pcall(require, 'telescope')
    if has_telescope then
      telescope.load_extension('aerial')
      
      -- Add telescope keymap for aerial symbols
      vim.keymap.set('n', '<leader>ss', '<cmd>Telescope aerial<cr>', { desc = '[S]earch [S]ymbols' })
    end
    
    -- Enhanced which-key integration
    local has_which_key, which_key = pcall(require, 'which-key')
    if has_which_key then
      which_key.add({
        { '<leader>c', group = '[C]ode' },
        { '<leader>cs', desc = '[C]ode [S]ymbols outline' },
        { '<leader>cS', desc = '[C]ode [S]ymbols navigation' },
        { ']s', desc = 'Next symbol' },
        { '[s', desc = 'Previous symbol' },
      })
    end
    
    -- Status line integration (for lualine)
    local has_lualine, lualine = pcall(require, 'lualine')
    if has_lualine then
      -- Add aerial symbol to lualine (will be empty if no symbols)
      local function aerial_symbol()
        local symbol = require('aerial').get_location(true)
        return symbol and symbol ~= '' and symbol or ''
      end
      
      -- This would be added to lualine sections if desired
      -- lualine.setup({ sections = { lualine_c = { aerial_symbol } } })
    end
    
    -- Apply TokyoNight theming
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'tokyonight*',
      callback = function()
        local colors = require('tokyonight.colors').setup()
        
        -- Aerial window highlights
        vim.api.nvim_set_hl(0, 'AerialNormal', {
          bg = colors.bg_sidebar,
          fg = colors.fg_sidebar,
        })
        vim.api.nvim_set_hl(0, 'AerialGuide', {
          fg = colors.dark3,
        })
        vim.api.nvim_set_hl(0, 'AerialLine', {
          bg = colors.bg_visual,
        })
        
        -- Symbol type highlights (matching LSP kinds)
        vim.api.nvim_set_hl(0, 'AerialClass', { fg = colors.orange })
        vim.api.nvim_set_hl(0, 'AerialFunction', { fg = colors.blue })
        vim.api.nvim_set_hl(0, 'AerialMethod', { fg = colors.blue })
        vim.api.nvim_set_hl(0, 'AerialVariable', { fg = colors.cyan })
        vim.api.nvim_set_hl(0, 'AerialConstant', { fg = colors.magenta })
        vim.api.nvim_set_hl(0, 'AerialStruct', { fg = colors.yellow })
        vim.api.nvim_set_hl(0, 'AerialInterface', { fg = colors.green })
        vim.api.nvim_set_hl(0, 'AerialEnum', { fg = colors.purple })
      end,
    })
    
    -- Apply highlights if TokyoNight is already loaded
    if vim.g.colors_name and vim.g.colors_name:match('tokyonight') then
      vim.cmd('doautocmd ColorScheme ' .. vim.g.colors_name)
    end
  end,
}