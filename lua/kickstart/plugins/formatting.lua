-- Advanced, battery-included formatting via conform.nvim
-- Focus: Rust, Python (uv/uvx), Lua, and pragmatic web/filetypes.
return {
  'stevearc/conform.nvim',

  -- Load just-in-time for formatting operations
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = { 'ConformInfo' },

  -- Keymaps for language-aware code operations (using <leader>c* namespace)
  keys = (function()
    local function map_desc(d)
      return { noremap = true, silent = true, desc = d }
    end

    return {
      -- Format whole buffer (async, LSP fallback) - keep existing <leader>cf
      {
        '<leader>cf',
        function()
          require('conform').format {
            async = true,
            lsp_format = 'fallback',
          }
        end,
        mode = { 'n' },
        desc = '[C]ode [F]ormat buffer',
      },

      -- Format selection/range in visual mode
      {
        '<leader>cf',
        function()
          local start = vim.api.nvim_buf_get_mark(0, '<')
          local finish = vim.api.nvim_buf_get_mark(0, '>')
          require('conform').format {
            async = true,
            lsp_format = 'fallback',
            range = {
              start = { start[1], start[2] },
              ['end'] = { finish[1], finish[2] },
            },
          }
          -- Exit visual mode after formatting
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(
            '<Esc>', true, false, true), 'n', false)
        end,
        mode = { 'x' },
        desc = '[C]ode [F]ormat selection',
      },

      -- Language-aware run operations
      {
        '<leader>cr',
        function()
          local ft = vim.bo.filetype
          if ft == 'rust' then
            vim.cmd('!cargo run')
          elseif ft == 'python' then
            vim.cmd('!python %')
          elseif ft == 'lua' then
            if vim.fn.expand('%:p'):match(vim.fn.stdpath('config')) then
              vim.cmd('source %')
              vim.notify('Sourced ' .. vim.fn.expand('%:t'))
            else
              vim.cmd('!lua %')
            end
          else
            vim.notify('No run command defined for ' .. ft, vim.log.levels.WARN)
          end
        end,
        desc = '[C]ode [R]un (language-aware)',
      },

      -- Language-aware test operations
      {
        '<leader>ct',
        function()
          local ft = vim.bo.filetype
          if ft == 'rust' then
            vim.cmd('!cargo test')
          elseif ft == 'python' then
            if vim.fn.glob('pytest.ini') ~= '' or vim.fn.glob('pyproject.toml') ~= '' then
              vim.cmd('!pytest')
            else
              vim.cmd('!python -m unittest discover')
            end
          elseif ft == 'lua' then
            if vim.fn.executable('busted') == 1 then
              vim.cmd('!busted %')
            else
              vim.notify('No test framework configured for Lua', vim.log.levels.INFO)
            end
          else
            vim.notify('No test command defined for ' .. ft, vim.log.levels.WARN)
          end
        end,
        desc = '[C]ode [T]est (language-aware)',
      },

      -- Toggle format-on-save for current buffer (moved from <leader>tF to avoid conflict)
      {
        '<leader>cF',
        function()
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          local msg = vim.b.disable_autoformat
              and 'Autoformat: OFF (buffer)'
              or  'Autoformat: ON (buffer)'
          vim.notify(msg, vim.log.levels.INFO)
        end,
        mode = { 'n' },
        desc = '[C]ode toggle [F]ormat on save',
      },

      -- Quick open Conform info panel (moved from <leader>ci to <leader>cI)
      {
        '<leader>cI',
        function() vim.cmd('ConformInfo') end,
        mode = { 'n' },
        desc = '[C]ode conform [I]nfo',
      },
    }
  end)(),
  opts = function()
    -- Helper: cheap executable checks
    local function has(cmd) return vim.fn.executable(cmd) == 1 end

    -- Prefer uvx to run Python tools (fast, isolated)
    local use_uvx = has('uvx')

    -- Global and buffer toggles honored here
    local function should_format_on_save(bufnr)
      -- Skip if toggled off globally or per-buffer
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return nil
      end
      -- Skip very large buffers to stay snappy
      local max = 20000
      if vim.api.nvim_buf_line_count(bufnr) > max then
        return nil
      end
      -- Apply sane defaults per Conform guidance
      return {
        lsp_format = 'fallback',
        timeout_ms = 800,
      }
    end

    -- Dynamic Python formatter selection.
    -- Prefer Ruff everywhere (formatter + fixes + imports).
    -- Fallback to isort+black when Ruff is unavailable.
    local function python_formatters(bufnr)
      local ok = require('conform')
        .get_formatter_info('ruff_format', bufnr).available
      if ok then
        return { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' }
      else
        return { 'isort', 'black' }
      end
    end

    -- Pragmatic web stack: prefer Rust-based tools (biome/dprint)
    local web = { 'biome', 'dprint', 'prettierd', 'prettier',
                  stop_after_first = true }

    return {
      -- Keep default LSP fallback behavior consistent
      default_format_opts = {
        lsp_format = 'fallback',
      },

      -- Set Conform's formatexpr for gq motions
      formatters_by_ft = {
        -- Core stack
        lua = { 'stylua' },
        rust = { 'rustfmt' },
        python = python_formatters,

        -- Shell & friends
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        fish = { 'fish_indent' },

        -- Data/config formats
        toml = { 'taplo' },       -- Fast TOML formatter
        yaml = { 'yamlfmt' },     -- Keeps comments w/ yamlfix alt
        json = web,               -- biome/dprint > prettier
        jsonc = web,
        markdown = { 'cbfmt', unpack(web) },
        md = { 'cbfmt', unpack(web) },

        -- Web stack
        javascript = web,
        javascriptreact = web,
        typescript = web,
        typescriptreact = web,
        css = web,
        scss = web,
        html = web,

        -- Proto & SQL (if installed)
        proto = { 'buf' },
        sql = { 'sqlfluff', 'pg_format', stop_after_first = true },

        -- Fallbacks for anything else
        ['*'] = {},
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
      },

      -- Respect toggles and large-file guard
      format_on_save = should_format_on_save,

      -- Quiet failure notifications, but still log in :ConformInfo
      notify_on_error = false,

      -- Fine-grained formatter customization & overrides
      formatters = (function()
        local f = {}

        -- Make `ruff_*` run via uvx when available
        if use_uvx then
          f.ruff_format = {
            inherit = false,
            command = 'uvx',
            args = {
              'ruff', 'format',
              '--stdin-filename', '$FILENAME', '-',
            },
            stdin = true,
          }
          f.ruff_fix = {
            inherit = false,
            command = 'uvx',
            args = {
              'ruff', 'check', '--fix',
              '--stdin-filename', '$FILENAME', '-',
            },
            stdin = true,
          }
          f.ruff_organize_imports = {
            inherit = false,
            command = 'uvx',
            args = {
              'ruff', 'check', '--select', 'I', '--fix',
              '--stdin-filename', '$FILENAME', '-',
            },
            stdin = true,
          }
        end

        -- shfmt preference: 2-space indent, case indent, binary ops
        f.shfmt = {
          append_args = { '-i', '2', '-ci', '-bn' },
        }

        -- dprint: only when dprint.json is present
        f.dprint = {
          condition = function(ctx)
            return vim.fs.find(
              { 'dprint.json', '.dprint.json' },
              { path = ctx.filename, upward = true }
            )[1] ~= nil
          end,
        }

        -- sqlfluff: only when config exists; otherwise skip
        f.sqlfluff = {
          condition = function(ctx)
            return vim.fs.find(
              { '.sqlfluff', '.sqlfluff.toml', 'pyproject.toml' },
              { path = ctx.filename, upward = true }
            )[1] ~= nil
          end,
        }

        return f
      end)(),
    }
  end,

  -- Final touches after setup
  config = function(_, opts)
    -- Apply plugin setup
    require('conform').setup(opts)

    -- Make built-in motions (gq) use Conform's minimal-diff engine
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    -- Optional global toggles via user commands
    vim.api.nvim_create_user_command('FormatDisable', function()
      vim.g.disable_autoformat = true
      vim.notify('Autoformat: OFF (global)', vim.log.levels.WARN)
    end, {})

    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.g.disable_autoformat = false
      vim.notify('Autoformat: ON (global)', vim.log.levels.INFO)
    end, {})

    vim.api.nvim_create_user_command('FormatToggle', function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      local msg = vim.g.disable_autoformat
          and 'Autoformat: OFF (global)'
          or  'Autoformat: ON (global)'
      vim.notify(msg, vim.log.levels.INFO)
    end, {})
  end,
}