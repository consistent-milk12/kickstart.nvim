-- Enhanced Treesitter Textobjects (v1.x compatible)
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  
  -- Ensure it loads after treesitter
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  
  -- Load when treesitter is ready
  event = { 'BufReadPost', 'BufNewFile' },
  
  config = function()
    -- Check if treesitter configs is available (compatibility check)
    local has_configs, configs = pcall(require, 'nvim-treesitter.configs')
    if not has_configs then
      -- Fallback: manual setup for new API
      vim.notify('Using manual textobjects setup for treesitter v1.x', vim.log.levels.INFO)
      
      -- Manual textobject keymaps using built-in treesitter
      local function setup_manual_textobjects()
        -- Function textobjects
        vim.keymap.set({ 'o', 'x' }, 'af', function()
          local node = vim.treesitter.get_node()
          if not node then return end
          
          -- Find function node
          while node and not node:type():match('function') do
            node = node:parent()
          end
          
          if node then
            local start_row, start_col, end_row, end_col = node:range()
            vim.api.nvim_buf_set_mark(0, '<', start_row + 1, start_col, {})
            vim.api.nvim_buf_set_mark(0, '>', end_row + 1, end_col - 1, {})
            vim.cmd('normal! gv')
          end
        end, { desc = 'Around function' })
        
        vim.keymap.set({ 'o', 'x' }, 'if', function()
          local node = vim.treesitter.get_node()
          if not node then return end
          
          -- Find function body
          while node and not (node:type():match('function') or node:type():match('body')) do
            node = node:parent()
          end
          
          if node and node:type():match('body') then
            local start_row, start_col, end_row, end_col = node:range()
            vim.api.nvim_buf_set_mark(0, '<', start_row + 1, start_col, {})
            vim.api.nvim_buf_set_mark(0, '>', end_row + 1, end_col - 1, {})
            vim.cmd('normal! gv')
          end
        end, { desc = 'Inner function' })
        
        -- Class textobjects
        vim.keymap.set({ 'o', 'x' }, 'ac', function()
          local node = vim.treesitter.get_node()
          if not node then return end
          
          while node and not (node:type():match('class') or node:type():match('struct') or node:type():match('impl')) do
            node = node:parent()
          end
          
          if node then
            local start_row, start_col, end_row, end_col = node:range()
            vim.api.nvim_buf_set_mark(0, '<', start_row + 1, start_col, {})
            vim.api.nvim_buf_set_mark(0, '>', end_row + 1, end_col - 1, {})
            vim.cmd('normal! gv')
          end
        end, { desc = 'Around class/struct' })
        
        -- Parameter textobjects
        vim.keymap.set({ 'o', 'x' }, 'aa', function()
          local node = vim.treesitter.get_node()
          if not node then return end
          
          while node and not node:type():match('parameter') do
            node = node:parent()
          end
          
          if node then
            local start_row, start_col, end_row, end_col = node:range()
            vim.api.nvim_buf_set_mark(0, '<', start_row + 1, start_col, {})
            vim.api.nvim_buf_set_mark(0, '>', end_row + 1, end_col - 1, {})
            vim.cmd('normal! gv')
          end
        end, { desc = 'Around parameter' })
        
        -- Movement keymaps
        vim.keymap.set('n', ']m', function()
          local node = vim.treesitter.get_node()
          if not node then return end
          
          -- Simple function movement (could be enhanced)
          local current_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_get_lines(0, current_line, -1, false)
          
          for i, line in ipairs(lines) do
            if line:match('function') or line:match('def ') or line:match('fn ') then
              vim.api.nvim_win_set_cursor(0, { current_line + i, 0 })
              return
            end
          end
        end, { desc = 'Next function' })
        
        vim.keymap.set('n', '[m', function()
          local current_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_get_lines(0, 0, current_line - 1, false)
          
          for i = #lines, 1, -1 do
            local line = lines[i]
            if line:match('function') or line:match('def ') or line:match('fn ') then
              vim.api.nvim_win_set_cursor(0, { i, 0 })
              return
            end
          end
        end, { desc = 'Previous function' })
        
        -- Class movement
        vim.keymap.set('n', ']k', function()
          local current_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_get_lines(0, current_line, -1, false)
          
          for i, line in ipairs(lines) do
            if line:match('class') or line:match('struct') or line:match('impl') then
              vim.api.nvim_win_set_cursor(0, { current_line + i, 0 })
              return
            end
          end
        end, { desc = 'Next class/struct' })
        
        vim.keymap.set('n', '[k', function()
          local current_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_get_lines(0, 0, current_line - 1, false)
          
          for i = #lines, 1, -1 do
            local line = lines[i]
            if line:match('class') or line:match('struct') or line:match('impl') then
              vim.api.nvim_win_set_cursor(0, { i, 0 })
              return
            end
          end
        end, { desc = 'Previous class/struct' })
      end
      
      setup_manual_textobjects()
      return
    end
    
    -- Traditional setup if configs is available
    configs.setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- Function textobjects
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            -- Class textobjects (using k to avoid git hunk conflicts)
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            -- Parameter textobjects
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            -- Block textobjects
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            ['ai'] = '@conditional.outer',
            ['ii'] = '@conditional.inner',
          },
          -- Enhanced selection modes
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          include_surrounding_whitespace = true,
        },
        
        move = {
          enable = true,
          set_jumps = true, -- Set jumps in jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']k'] = '@class.outer', -- Changed from ]c to avoid git conflict
            [']a'] = '@parameter.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[k'] = '@class.outer', -- Changed from [c to avoid git conflict  
            ['[a'] = '@parameter.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']K'] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[K'] = '@class.outer',
          },
        },
        
        swap = {
          enable = true,
          swap_next = {
            ['g>'] = '@parameter.inner',
          },
          swap_previous = {
            ['g<'] = '@parameter.inner',
          },
        },
        
        -- LSP integration for peek definition
        lsp_interop = {
          enable = true,
          border = 'single',
          peek_definition_code = {
            ['<leader>df'] = '@function.outer',
            ['<leader>dF'] = '@class.outer',
          },
        },
      },
    })
  end,
}