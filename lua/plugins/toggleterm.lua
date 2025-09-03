-- Advanced terminal management with multiple directions and floating windows
-- Integrates seamlessly with TokyoNight theme and existing workflow
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = '󰆍 Terminal Float' },
    { '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = '󰆍 Terminal Horizontal' },
    { '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = '󰆍 Terminal Vertical' },
    { '<leader>tt', '<cmd>ToggleTerm<cr>', desc = '󰆍 Toggle Terminal' },
    { '<C-\\>', '<cmd>ToggleTerm<cr>', desc = '󰆍 Quick Terminal', mode = { 'n', 'i', 't' } },
  },
  config = function()
    require('toggleterm').setup {
      -- Size configuration
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,

      -- Terminal behavior
      open_mapping = [[<C-\>]], -- Quick toggle
      hide_numbers = true, -- Hide line numbers in terminal
      shade_terminals = true, -- Shade non-active terminals
      shading_factor = 2, -- Degree of shading
      start_in_insert = true, -- Start in insert mode
      persist_size = true, -- Remember terminal size
      direction = 'float', -- Default direction
      close_on_exit = true, -- Close when process exits
      shell = vim.o.shell, -- Use default shell

      -- Autochdir to follow nvim working directory
      auto_chdir = true,

      -- Floating terminal configuration
      float_opts = {
        border = 'curved', -- Matches other plugin borders
        width = function()
          return math.floor(vim.o.columns * 0.85)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        winblend = 3, -- Slight transparency
        -- Center the terminal
        row = function()
          return math.floor(vim.o.lines * 0.1)
        end,
        col = function()
          return math.floor(vim.o.columns * 0.075)
        end,
      },

      -- Window options
      winbar = {
        enabled = false,
      },

      -- Highlights (TokyoNight integration)
      highlights = {
        Normal = {
          link = 'Normal',
        },
        NormalFloat = {
          link = 'NormalFloat',
        },
        FloatBorder = {
          link = 'FloatBorder',
        },
      },

      -- Execute commands on terminal creation
      on_create = function(term)
        vim.opt_local.foldcolumn = '0'
        vim.opt_local.signcolumn = 'no'

        -- Terminal-specific keymaps
        local opts = { buffer = term.bufnr }
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end,

      -- Terminal exit handling
      on_exit = function(term)
        if term.job_id and vim.fn.jobwait({ term.job_id }, 0)[1] == -1 then
          vim.fn.jobstop(term.job_id)
        end
      end,
    }

    -- Custom terminal functions
    local Terminal = require('toggleterm.terminal').Terminal

    -- Lazygit terminal (since we mentioned git integration)
    if vim.fn.executable 'lazygit' == 1 then
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        dir = 'git_dir',
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
        on_open = function(term)
          vim.cmd 'startinsert!'
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
        on_close = function(term)
          vim.cmd 'startinsert!'
        end,
      }

      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set('n', '<leader>gg', '<cmd>lua _lazygit_toggle()<CR>', { desc = '󰊢 LazyGit' })
    end

    -- Node REPL
    if vim.fn.executable 'node' == 1 then
      local node = Terminal:new { cmd = 'node', hidden = true }
      function _node_toggle()
        node:toggle()
      end
      vim.keymap.set('n', '<leader>tn', '<cmd>lua _node_toggle()<CR>', { desc = '󰎙 Node REPL' })
    end

    -- Python REPL
    if vim.fn.executable 'python' == 1 then
      local python = Terminal:new { cmd = 'python', hidden = true }
      function _python_toggle()
        python:toggle()
      end
      vim.keymap.set('n', '<leader>tp', '<cmd>lua _python_toggle()<CR>', { desc = ' Python REPL' })
    end
  end,
}

