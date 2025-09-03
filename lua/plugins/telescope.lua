-- Telescope: power-user setup for Neovim 0.12
-- - Fast sorting with fzf-native (if buildable)
-- - Live grep with arbitrary ripgrep args
-- - File browser, frecency, undo tree, zoxide, DAP pickers
-- - Trouble.nvim integration from inside pickers
-- - Opinionated defaults for layout, ignore patterns, and UX
-- - Keymaps for an advanced workflow (see bottom)

return {
  -- Core fuzzy finder
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',

  -- Extensions & deps
  dependencies = {
    -- Required runtime
    'nvim-lua/plenary.nvim',

    -- Native sorter (C) for large repos
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },

    -- vim.ui.select powered by Telescope
    'nvim-telescope/telescope-ui-select.nvim',

    -- Live grep with extra args & prompt quoting
    'nvim-telescope/telescope-live-grep-args.nvim',

    -- File management inside Telescope
    'nvim-telescope/telescope-file-browser.nvim',

    -- Smarter recents (frecency). Uses SQLite if available.
    'nvim-telescope/telescope-frecency.nvim',

    -- Visual undo tree as a picker
    'debugloop/telescope-undo.nvim',

    -- Zoxide directory jumping
    'jvgrootveld/telescope-zoxide',

    -- DAP integration (configurations, breakpoints, etc.)
    'nvim-telescope/telescope-dap.nvim',

    -- Optional icons (Nerd Font recommended)
    { 'echasnovski/mini.icons', enabled = vim.g.have_nerd_font },
  },

  config = function()
    -- Local requires for actions and themes
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
    local lga_actions = require 'telescope-live-grep-args.actions'
    local themes = require 'telescope.themes'
    -- Oil integration
    local oil = require 'oil'

    -- Resolve a filesystem path from a Telescope entry
    -- Works across file, grep, buffers and custom pickers
    local function _entry_path(entry)
      if not entry then
        return nil
      end
      if entry.path and entry.path ~= '' then
        return entry.path
      end
      if entry.filename and entry.filename ~= '' then
        return entry.filename
      end
      if entry.value and type(entry.value) == 'string' then
        return entry.value
      end
      if entry.bufnr and vim.api.nvim_buf_is_loaded(entry.bufnr) then
        local name = vim.api.nvim_buf_get_name(entry.bufnr)
        if name ~= '' then
          return name
        end
      end
      return nil
    end

    -- Open Oil for a path. If a file is given, open Oil at its parent
    -- directory and jump the cursor to that filename.
    local function _reveal_in_oil(path, as_float)
      if not path or path == '' then
        return
      end
      local stat = vim.uv.fs_stat(path)
      local open = as_float and oil.open_float or oil.open
      if stat and stat.type == 'directory' then
        open(path)
        return
      end
      local dir = vim.fs.dirname(path)
      local base = vim.fs.basename(path)
      open(dir, nil, function()
        -- Jump to the line that matches the filename
        vim.schedule(function()
          local pat = '^' .. vim.pesc(base) .. '$'
          vim.fn.search(pat, 'w')
          vim.cmd 'normal! zz'
        end)
      end)
    end

    -- Trouble integration from Telescope
    -- (press <C-t> inside a picker to open results in Trouble)
    local trouble_open = require('trouble.sources.telescope').open
    local trouble_add = require('trouble.sources.telescope').add

    -- Prefer fd for find_files; fall back to rg if needed
    local find_cmd
    if vim.fn.executable 'fd' == 1 then
      find_cmd = {
        'fd',
        '--type',
        'f',
        '--strip-cwd-prefix',
        '--hidden',
        '--follow',
        '--exclude',
        '.git',
      }
    elseif vim.fn.executable 'rg' == 1 then
      find_cmd = {
        'rg',
        '--files',
        '--hidden',
        '--follow',
        '--glob',
        '!.git',
      }
    end

    -- Conservative file ignore patterns
    local ignore = {
      '.git/',
      'target/',
      'node_modules/',
      '.venv/',
      '__pycache__/',
      'dist/',
      'build/',
      '.cache/',
    }

    -- Use a calm, information-dense UI that suits tokyonight
    telescope.setup {
      -- Global defaults for all pickers
      defaults = {
        -- Show prompt at top; ascending results feel natural
        sorting_strategy = 'ascending',
        layout_strategy = 'flex',

        -- Compact, legible layout
        layout_config = {
          prompt_position = 'top',
          horizontal = { preview_width = 0.55, width = 0.95 },
          vertical = { preview_height = 0.45, width = 0.95 },
          height = 0.92,
        },

        -- Smart truncate long paths
        path_display = { 'smart' },

        -- Ignore noisy folders
        file_ignore_patterns = ignore,

        -- Prefer ripgrep for greps (smart-case, hidden, VCS aware)
        vimgrep_arguments = {
          'rg',
          '--vimgrep',
          '--smart-case',
          '--hidden',
          '--follow',
          '--no-ignore-vcs',
        },

        -- Scrolling & selection behavior
        dynamic_preview_title = true,
        selection_caret = '› ',
        multi_icon = '+',

        -- Insert & normal mode mappings inside pickers
        mappings = {
          -- Insert mode
          i = {
            -- Movement between results
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,

            -- Preview scrolling
            ['<C-u>'] = actions.preview_scrolling_up,
            ['<C-d>'] = actions.preview_scrolling_down,

            -- Toggle and send to quickfix
            ['<Tab>'] = actions.toggle_selection + actions.move_selection_next,
            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_previous,
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,

            -- Trouble: open current results
            ['<C-t>'] = trouble_open,
            -- Trouble: add more results without clearing
            ['<M-t>'] = trouble_add,

            -- History (per-prompt; improved by smart-history/frecency)
            ['<C-n>'] = actions.cycle_history_next,
            ['<C-p>'] = actions.cycle_history_prev,

            -- Which-key style help for picker actions
            ['<C-/>'] = actions.which_key,
            -- Reveal selected item in Oil (float)
            ['<M-o>'] = function(prompt_bufnr)
              local entry = action_state.get_selected_entry()
              local p = _entry_path(entry)
              if p then
                _reveal_in_oil(p, true)
              end
            end,
            -- Open containing directory in Oil (float)
            ['<M-O>'] = function(prompt_bufnr)
              local entry = action_state.get_selected_entry()
              local p = _entry_path(entry)
              if p then
                _reveal_in_oil(vim.fs.dirname(p), true)
              end
            end,
          },

          -- Normal mode
          n = {
            ['q'] = actions.close,
            ['?'] = actions.which_key,
            ['<C-t>'] = trouble_open,
            ['<M-t>'] = trouble_add,
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            -- Same Oil integrations for normal mode
            ['<M-o>'] = function(prompt_bufnr)
              local entry = action_state.get_selected_entry()
              local p = _entry_path(entry)
              if p then
                _reveal_in_oil(p, true)
              end
            end,
            ['<M-O>'] = function(prompt_bufnr)
              local entry = action_state.get_selected_entry()
              local p = _entry_path(entry)
              if p then
                _reveal_in_oil(vim.fs.dirname(p), true)
              end
            end,
          },
        },
      },

      -- Per-picker tweaks
      pickers = {
        -- Buffers: MRU first; don't show the current buffer
        buffers = {
          sort_mru = true,
          ignore_current_buffer = true,
          mappings = {
            i = {
              -- Delete buffer with <C-x> (safe in picker)
              ['<C-x>'] = actions.delete_buffer,
            },
            n = {
              ['x'] = actions.delete_buffer,
            },
          },
        },

        -- Find files: prefer fd/rg command, show hidden files
        find_files = {
          find_command = find_cmd,
          hidden = true,
          no_ignore = false,
          follow = true,
        },

        -- Colorscheme preview that fits floating UI
        colorscheme = themes.get_dropdown {
          enable_preview = true,
        },
      },

      -- Extension configurations
      extensions = {
        -- fzf-native: improved sorters
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },

        -- live_grep_args: quote prompt, add flags quickly
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              -- Quote prompt (exact search)
              ['<C-k>'] = lga_actions.quote_prompt(),
              -- Add/remove flags (removed to_fuzzy_refine as it doesn't exist)
              ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
            },
          },
        },

        -- file browser: start at current buffer dir
        file_browser = {
          hijack_netrw = true,
          grouped = true,
          respect_gitignore = true,
          hidden = true,
        },

        -- frecency: show by recency/usage (SQLite if present)
        frecency = {
          show_scores = true,
          show_unindexed = false,
          auto_validate = true,
        },

        -- undo: browse and yank changes
        undo = {
          use_delta = true,
          side_by_side = true,
          layout_strategy = 'vertical',
          layout_config = { preview_height = 0.7 },
        },

        -- zoxide: jump across projects fast
        zoxide = {
          prompt_title = 'Zoxide',
        },

        -- ui-select: use a dropdown that matches the UX
        ['ui-select'] = themes.get_dropdown(),
      },
    }

    -- Load extensions (protected calls to avoid hard failures)
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
    pcall(telescope.load_extension, 'live_grep_args')
    pcall(telescope.load_extension, 'file_browser')
    pcall(telescope.load_extension, 'frecency')
    pcall(telescope.load_extension, 'undo')
    pcall(telescope.load_extension, 'zoxide')
    pcall(telescope.load_extension, 'dap')

    -- Shorthand to builtins
    local b = require 'telescope.builtin'

    -- Helper to open file_browser rooted at the buffer's dir
    local function fb_here()
      telescope.extensions.file_browser.file_browser {
        cwd = vim.fn.expand '%:p:h',
        select_buffer = true,
      }
    end

    -- Helper to live_grep with args (open files only variant)
    local function lga_open_files()
      telescope.extensions.live_grep_args.live_grep_args {
        grep_open_files = true,
        prompt_title = 'Grep in Open Files (args)',
      }
    end

    -- Keymaps (discoverable via which-key)
    -- Search group
    vim.keymap.set('n', '<leader>ss', b.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sf', b.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sg', b.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sG', telescope.extensions.live_grep_args.live_grep_args, { desc = '[S]earch Grep with [A]rgs' })
    vim.keymap.set('n', '<leader>s/', lga_open_files, { desc = '[S]earch [/] open files (args)' })
    vim.keymap.set('n', '<leader>sw', b.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sb', b.buffers, { desc = '[S]earch [B]uffers' })
    vim.keymap.set('n', '<leader>sh', b.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', b.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sc', b.colorscheme, { desc = '[S]earch [C]olorschemes' })
    vim.keymap.set('n', '<leader>sm', b.marks, { desc = '[S]earch [M]arks' })
    vim.keymap.set('n', '<leader>sj', b.jumplist, { desc = '[S]earch [J]umps' })
    vim.keymap.set('n', '<leader>sr', b.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', telescope.extensions.frecency.frecency, { desc = '[S]earch recent files (frecency)' })
    vim.keymap.set('n', '<leader>su', telescope.extensions.undo.undo, { desc = '[S]earch [U]ndo history' })
    vim.keymap.set('n', '<leader>sd', b.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>st', function()
      b.diagnostics()
      vim.schedule(function()
        vim.cmd 'Trouble diagnostics toggle'
      end)
    end, { desc = '[S]how diagnostics in [T]rouble' })

    -- In-buffer fuzzy find as a dropdown
    vim.keymap.set('n', '<leader>/', function()
      b.current_buffer_fuzzy_find(themes.get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = 'Fuzzy search in buffer' })

    -- Oil helpers from normal mode
    vim.keymap.set('n', '<leader>fo', function()
      -- Reveal current file in an Oil float
      local name = vim.api.nvim_buf_get_name(0)
      if name ~= '' then
        _reveal_in_oil(name, true)
      else
        oil.open_float()
      end
    end, { desc = '[F]ile: reveal current file in [O]il' })

    vim.keymap.set('n', '<leader>fO', function()
      -- Open CWD in an Oil float
      local cwd = vim.uv.cwd() or vim.fn.getcwd(0, 0)
      _reveal_in_oil(cwd, true)
    end, { desc = '[F]ile: open CWD in [O]il' })

    -- LSP pickers
    vim.keymap.set('n', '<leader>sl', b.lsp_document_symbols, { desc = '[S]ymbols ([L]ocal document)' })
    vim.keymap.set('n', '<leader>sL', b.lsp_dynamic_workspace_symbols, { desc = '[S]ymbols ([L]SP workspace)' })
    vim.keymap.set('n', '<leader>srf', b.lsp_references, { desc = '[S]earch LSP [R]eferences' })
    vim.keymap.set('n', '<leader>si', b.lsp_implementations, { desc = '[S]earch LSP [I]mplementations' })

    -- Git pickers
    vim.keymap.set('n', '<leader>gc', b.git_commits, { desc = '[G]it [C]ommits' })
    vim.keymap.set('n', '<leader>gC', b.git_bcommits, { desc = '[G]it buffer [C]ommits' })
    vim.keymap.set('n', '<leader>gb', b.git_branches, { desc = '[G]it [B]ranches' })
    vim.keymap.set('n', '<leader>gs', b.git_status, { desc = '[G]it [S]tatus' })
    vim.keymap.set('n', '<leader>gS', b.git_stash, { desc = '[G]it [S]tash' })

    -- Filesystem helpers
    vim.keymap.set('n', '<leader>fe', fb_here, { desc = '[F]ile [E]xplorer (here)' })
    vim.keymap.set('n', '<leader>fz', telescope.extensions.zoxide.list, { desc = '[F]ile jump with [Z]oxide' })

    -- DAP pickers (if nvim-dap is installed)
    vim.keymap.set('n', '<leader>dd', telescope.extensions.dap.commands, { desc = '[D]AP [D]ebug commands' })
    vim.keymap.set('n', '<leader>db', telescope.extensions.dap.list_breakpoints, { desc = '[D]AP [B]reakpoints' })
    vim.keymap.set('n', '<leader>dv', telescope.extensions.dap.variables, { desc = '[D]AP [V]ariables' })
    vim.keymap.set('n', '<leader>df', telescope.extensions.dap.frames, { desc = '[D]AP [F]rames' })

    -- Neovim config quick access
    vim.keymap.set('n', '<leader>sn', function()
      b.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim config' })
  end,
}
