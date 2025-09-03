return {
  -- Rust IDE features for Neovim (no lspconfig required)
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false, -- plugin is already filetype-lazy internally
  init = function()
    -- Configure before plugin loads (required by rustaceanvim)
    vim.g.rustaceanvim = {
      -- Extra tooling from rustaceanvim
      tools = {
        -- Focus the hover actions UI immediately (VSCode-like)
        hover_actions = { auto_focus = true, border = 'rounded' },
        -- Run tests in background & surface failures as diagnostics
        test_executor = 'background',
      },

      -- Debug adapter: autoload rust DAP configs when RA is ready
      dap = { autoload_configurations = true },

      -- LSP server config & rust-analyzer settings
      server = {
        on_attach = function(client, bufnr)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          -- Prefer native inlay hints (enable on attach)
          vim.defer_fn(function()
            pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
          end, 50)

          -- ==== Rust-specific power keymaps (only in Rust buffers) ====
          -- Organized under <leader>c* namespace to match existing code operations
          
          -- Core code actions and fixes
          map({ 'n', 'x' }, '<leader>ca', function() vim.cmd.RustLsp('codeAction') end, 'Rust: Code Actions (grouped)')
          map('n', '<leader>co', function()
            vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
          end, 'Rust: Organize Imports')
          map({ 'n', 'x' }, '<leader>cA', function()
            vim.lsp.buf.code_action({ context = { only = { 'source.fixAll' } }, apply = true })
          end, 'Rust: Fix All Issues')

          -- Enhanced run/test operations (integrate with existing <leader>cr/ct)
          map('n', '<leader>cR', function() vim.cmd.RustLsp('runnables') end, 'Rust: Runnables (advanced)')
          map('n', '<leader>cT', function() vim.cmd.RustLsp('testables') end, 'Rust: Testables (advanced)')
          map('n', '<leader>cd', function() vim.cmd.RustLsp('debuggables') end, 'Rust: Debuggables')

          -- Rust-specific tools and diagnostics
          map('n', '<leader>ce', function() vim.cmd.RustLsp('explainError') end, 'Rust: Explain Error')
          map('n', '<leader>cm', function() vim.cmd.RustLsp('expandMacro') end, 'Rust: Expand Macro')
          map('n', '<leader>cp', function() vim.cmd.RustLsp('parentModule') end, 'Rust: Parent Module')
          map('n', '<leader>cD', function() vim.cmd.RustLsp('openDocs') end, 'Rust: Open Docs')
          map('n', '<leader>cG', function() vim.cmd.RustLsp('crateGraph') end, 'Rust: Crate Graph')

          -- Toggle inlay hints (integrate with existing <leader>th pattern)
          map('n', '<leader>ci', function()
            local on = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(not on, { bufnr = bufnr })
          end, 'Rust: Toggle Inlay Hints')

          -- Enhanced hover with actions
          map('n', 'K', function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, 'Rust: Hover Actions')

          -- Optional: soften inlay hint appearance for long sessions (TokyoNight-friendly)
          vim.api.nvim_set_hl(0, 'LspInlayHint', { link = 'Comment' })
        end,

        -- Rust Analyzer settings mapped from VSCode configuration
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              allTargets = true,
              buildScripts = { enable = true },
              features = 'all',
            },

            check = {
              command = 'clippy',
              extraArgs = { '--', '-W', 'clippy::all' },
            },

            diagnostics = {
              enable = true,
              experimental = { enable = false },
              styleLints = { enable = true },
            },

            rustfmt = {
              rangeFormatting = { enable = true },
              -- Mirror group_imports preference
              extraArgs = { '--config', 'group_imports=StdExternalCrate' },
            },

            completion = {
              autoimport = { enable = true },
              autoself = { enable = true },
              callable = { snippets = 'fill_arguments' },
              termSearch = { enable = true }, -- search for type/term completions
              postfix = { enable = true },
            },

            assist = {
              emitMustUse = true,
              expressionFillDefault = 'default',
              termSearch = { borrowcheck = true, fuel = 1800 },
            },

            imports = { granularity = { enforce = true } },

            -- Inlay hints tuned for ergonomics
            inlayHints = {
              bindingModeHints = { enable = false },
              chainingHints = { enable = true },
              closingBraceHints = { enable = false, minLines = 25 },
              closureReturnTypeHints = { enable = 'with_block' },
              discriminantHints = { enable = 'fieldless' },
              expressionAdjustmentHints = { enable = 'never' },
              lifetimeElisionHints = { enable = 'skip_trivial' },
              parameterHints = { enable = true },
              typeHints = {
                enable = true,
                hideClosureInitialization = true,
                hideNamedConstructor = true,
              },
              maxLength = 25,
              renderColons = true,
            },

            -- Semantic highlighting refinements
            semanticHighlighting = {
              strings = { enable = true },
              operator = { enable = true, specialization = { enable = true } },
              punctuation = {
                enable = true,
                specialization = { enable = true },
                separate = { macro = { bang = true } },
              },
              nonStandardTokens = true,
            },

            hover = {
              actions = {
                enable = true,
                debug = { enable = true },
                gotoTypeDef = { enable = true },
                implementations = { enable = true },
                run = { enable = true },
                documentation = { enable = true },
                links = { enable = true },
              },
            },

            lens = {
              enable = true,
              run = { enable = true },
              debug = { enable = true },
              implementations = { enable = true },
            },

            procMacro = { enable = true, attributes = { enable = true } },

            cachePriming = { enable = true, numThreads = 8 },
          },
        },
      },
    }
  end,
}