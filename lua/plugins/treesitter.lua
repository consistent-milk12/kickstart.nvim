-- Advanced Treesitter configuration (v1.x - new API)
return {
  -- Core Treesitter plugin (new API)
  'nvim-treesitter/nvim-treesitter',

  -- Track main branch (required for new API)
  branch = 'main',

  -- Load eagerly (treesitter doesn't support lazy loading)
  lazy = false,

  -- Keep parsers updated
  build = ':TSUpdate',

  -- Related plugins
  dependencies = {
    -- Context-aware commentstring
    'JoosepAlviste/nvim-ts-context-commentstring',
    -- Auto close/rename HTML/JSX/Vue tags
    'windwp/nvim-ts-autotag',
    -- Sticky code context header
    'nvim-treesitter/nvim-treesitter-context',
    -- Function argument highlighting
    'm-demare/hlargs.nvim',
    -- TS-aware % matching
    'andymass/vim-matchup',
  },

  -- New API configuration
  config = function()
    -- Helper: return true for very large buffers (size/lines)
    local function is_big_file(bufnr)
      -- 1.5 MiB threshold
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size and stats.size > 1.5 * 1024 * 1024 then
        return true
      end
      -- 25k line threshold
      local lines = vim.api.nvim_buf_line_count(bufnr)
      return lines > 25000
    end

    -- Core treesitter setup (new API)
    require('nvim-treesitter').setup({
      -- Install directory for parsers
      install_dir = vim.fn.stdpath('data') .. '/site',
    })

    -- Install essential parsers
    local parsers = {
      'bash', 'c', 'diff', 'html', 'css', 'javascript', 'json',
      'lua', 'luadoc', 'markdown', 'markdown_inline', 'python',
      'query', 'regex', 'rust', 'toml', 'vim', 'vimdoc',
      'git_config', 'gitattributes', 'gitcommit', 'git_rebase', 'yaml',
    }
    require('nvim-treesitter').install(parsers)

    -- Enable highlighting via autocmd (new way)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = parsers,
      callback = function(args)
        if not is_big_file(args.buf) then
          vim.treesitter.start(args.buf)
        end
      end,
    })

    -- Enable indentation for selected filetypes (experimental)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'lua', 'rust', 'javascript', 'html', 'css' },
      callback = function(args)
        if not is_big_file(args.buf) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
    
    -- Enable treesitter-based folding with performance guards
    local function setup_treesitter_folding()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers, -- Use same parser list as highlighting
        callback = function(args)
          local bufnr = args.buf
          
          -- Skip folding for big files
          if is_big_file(bufnr) then
            return
          end
          
          -- Only enable for files with reasonable complexity
          local line_count = vim.api.nvim_buf_line_count(bufnr)
          if line_count < 50 or line_count > 5000 then
            return
          end
          
          -- Set up treesitter folding
          vim.wo.foldmethod = 'expr'
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldlevel = 99 -- Start with all folds open
          vim.wo.foldlevelstart = 99 -- Start with all folds open for new files
          
          -- Configure fold display
          vim.wo.foldcolumn = '1' -- Show fold column
          vim.wo.fillchars = vim.wo.fillchars .. ',fold: ,foldopen:,foldsep:│,foldclose:'
          
          -- Smart fold opening for better UX
          vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
            buffer = bufnr,
            callback = function()
              -- Open all folds on file read
              vim.defer_fn(function()
                pcall(vim.cmd.normal, 'zR')
              end, 100)
            end,
          })
          
          -- Keymaps for folding (only set for buffers with folding enabled)
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set('n', 'zC', 'zM', vim.tbl_extend('force', opts, { desc = 'Close all folds' }))
          vim.keymap.set('n', 'zO', 'zR', vim.tbl_extend('force', opts, { desc = 'Open all folds' }))
          vim.keymap.set('n', 'z1', function() vim.wo.foldlevel = 1 end, vim.tbl_extend('force', opts, { desc = 'Fold level 1' }))
          vim.keymap.set('n', 'z2', function() vim.wo.foldlevel = 2 end, vim.tbl_extend('force', opts, { desc = 'Fold level 2' }))
          vim.keymap.set('n', 'z3', function() vim.wo.foldlevel = 3 end, vim.tbl_extend('force', opts, { desc = 'Fold level 3' }))
          vim.keymap.set('n', 'z4', function() vim.wo.foldlevel = 4 end, vim.tbl_extend('force', opts, { desc = 'Fold level 4' }))
          vim.keymap.set('n', 'z5', function() vim.wo.foldlevel = 5 end, vim.tbl_extend('force', opts, { desc = 'Fold level 5' }))
        end,
      })
    end
    
    setup_treesitter_folding()

    -- Configure plugins that depend on treesitter
    -- Skip deprecated context_commentstring integration
    vim.g.skip_ts_context_commentstring_module = true

    -- Setup context_commentstring separately
    require('ts_context_commentstring').setup({
      enable_autocmd = false,
    })

    -- Configure the sticky context header
    require('treesitter-context').setup({
      enable = true,
      max_lines = 3,
      min_window_height = 12,
      line_numbers = true,
      multiline_threshold = 15,
      trim_scope = 'outer',
      mode = 'cursor',
      separator = '▔',
      zindex = 20,
    })

    -- Setup autotag
    require('nvim-ts-autotag').setup({
      opts = {
        enable_close_on_slash = false,
      },
    })

    -- Setup hlargs
    require('hlargs').setup({
      color = nil,
      use_colorpalette = true,
      excluded_argnames = {
        usages = {
          python = { 'self', 'cls' },
          lua = { 'self' },
        },
      },
      disable = function(_, bufnr)
        return is_big_file(bufnr)
      end,
    })

    -- Incremental selection using built-in treesitter functions
    local function setup_incremental_selection()
      -- Start incremental selection
      vim.keymap.set('n', '<C-Space>', function()
        -- Enter visual mode and select current node
        local node = vim.treesitter.get_node()
        if node then
          local start_row, start_col, end_row, end_col = node:range()
          vim.api.nvim_buf_set_mark(0, '<', start_row + 1, start_col, {})
          vim.api.nvim_buf_set_mark(0, '>', end_row + 1, end_col - 1, {})
          vim.cmd('normal! gv')
        end
      end, { desc = 'Start incremental selection' })
      
      -- Expand selection to parent node
      vim.keymap.set('v', '<C-Space>', function()
        local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
        local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, '>'))
        
        -- Get node at current selection start
        local node = vim.treesitter.get_node({ pos = { start_row - 1, start_col } })
        if node and node:parent() then
          local parent = node:parent()
          local p_start_row, p_start_col, p_end_row, p_end_col = parent:range()
          vim.api.nvim_buf_set_mark(0, '<', p_start_row + 1, p_start_col, {})
          vim.api.nvim_buf_set_mark(0, '>', p_end_row + 1, p_end_col - 1, {})
          vim.cmd('normal! gv')
        end
      end, { desc = 'Expand selection' })
      
      -- Shrink selection to child node
      vim.keymap.set('v', '<BS>', function()
        local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
        local node = vim.treesitter.get_node({ pos = { start_row - 1, start_col } })
        
        if node then
          -- Find first child node that contains meaningful content
          local child = node:child(0)
          while child do
            local child_start_row, child_start_col, child_end_row, child_end_col = child:range()
            -- Skip trivial single-character nodes
            if (child_end_row - child_start_row > 0) or (child_end_col - child_start_col > 1) then
              vim.api.nvim_buf_set_mark(0, '<', child_start_row + 1, child_start_col, {})
              vim.api.nvim_buf_set_mark(0, '>', child_end_row + 1, child_end_col - 1, {})
              vim.cmd('normal! gv')
              return
            end
            child = child:next_sibling()
          end
        end
      end, { desc = 'Shrink selection' })
      
      -- Scope-based incremental selection (for blocks, functions, etc.)
      vim.keymap.set('v', '<C-g>', function()
        local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
        local node = vim.treesitter.get_node({ pos = { start_row - 1, start_col } })
        
        -- Find scope-like parent (function, class, block, etc.)
        while node do
          local node_type = node:type()
          if node_type:match('function') or node_type:match('class') or 
             node_type:match('block') or node_type:match('body') or
             node_type:match('statement') then
            local scope_start_row, scope_start_col, scope_end_row, scope_end_col = node:range()
            vim.api.nvim_buf_set_mark(0, '<', scope_start_row + 1, scope_start_col, {})
            vim.api.nvim_buf_set_mark(0, '>', scope_end_row + 1, scope_end_col - 1, {})
            vim.cmd('normal! gv')
            return
          end
          node = node:parent()
        end
      end, { desc = 'Select by scope' })
    end
    
    setup_incremental_selection()
    
    -- Textobjects are now handled by treesitter-textobjects.lua plugin

    -- Apply TokyoNight highlights
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'tokyonight*',
      callback = function()
        local colors = require('tokyonight.colors').setup()
        
        -- Context highlights
        vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = colors.bg_dark, fg = colors.fg })
        vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { underline = true, sp = colors.border })
        vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = colors.dark3, bg = colors.bg_dark })
        vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', { fg = colors.border })
        
        -- Hlargs highlights
        vim.api.nvim_set_hl(0, 'Hlargs', { fg = colors.yellow, italic = true })
        
        -- Matchup highlights
        vim.api.nvim_set_hl(0, 'MatchParen', { bg = colors.bg_highlight, bold = true })
        vim.api.nvim_set_hl(0, 'MatchParenCur', { bg = colors.bg_highlight, bold = true })
        vim.api.nvim_set_hl(0, 'MatchWord', { bg = colors.bg_visual, underline = true })
        vim.api.nvim_set_hl(0, 'MatchWordCur', { bg = colors.bg_visual, underline = true })
      end,
    })
    
    if vim.g.colors_name and vim.g.colors_name:match('tokyonight') then
      vim.cmd('doautocmd ColorScheme ' .. vim.g.colors_name)
    end
  end,
}

