-- Advanced Treesitter configuration with textobjects, context, and visual enhancements
return {
  -- Core Treesitter plugin (configs + modules)
  "nvim-treesitter/nvim-treesitter",

  -- Keep parsers up to date whenever the plugin updates
  build = ":TSUpdate",

  -- Use the configs module for opts injection
  main = "nvim-treesitter.configs",

  -- Related, battle-tested add-ons (loaded alongside)
  dependencies = {
    -- Advanced textobjects (select/move/swap)
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- Correct commentstring inside embedded languages
    "JoosepAlviste/nvim-ts-context-commentstring",
    -- Auto close/rename HTML/JSX/Vue tags
    "windwp/nvim-ts-autotag",
    -- Sticky code context at the top of the window
    "nvim-treesitter/nvim-treesitter-context",
    -- Rainbow parentheses/tags via TS queries (commented out - can be aggressive)
    -- "HiPhish/rainbow-delimiters.nvim",
    -- Highlight function arguments (defs/usages)
    "m-demare/hlargs.nvim",
    -- Smarter % matching with TS awareness
    "andymass/vim-matchup",
  },

  -- Treesitter setup options (applied to configs.setup)
  opts = function()
    -- Helper: return true for very large buffers (size/lines)
    local function bigfile(bufnr)
      -- 1.5 MiB threshold (tune for your machine)
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size and stats.size > 1.5 * 1024 * 1024 then
        return true
      end
      -- 25k line threshold (guards pathological files)
      local lines = vim.api.nvim_buf_line_count(bufnr)
      return lines > 25000
    end

    -- Preferred parser set for Rust/Python/Lua + essentials
    local parsers = {
      "bash", "c", "diff", "html", "css", "javascript",
      "json", "lua", "luadoc", "markdown", "markdown_inline",
      "python", "query", "regex", "rust", "toml", "vim", "vimdoc",
      -- Git related (nice quality-of-life in commits/rebases)
      "git_config", "gitattributes", "gitcommit", "git_rebase",
      -- Extras frequently encountered in docs/config
      "yaml",
    }

    -- Return the final opts table to configs.setup
    return {
      -- Ensure a useful parser baseline, but allow ad-hoc installs
      ensure_installed = parsers,

      -- Pull missing parsers automatically on first encounter
      auto_install = true,

      -- Treesitter-powered highlighting (guarded for big files)
      highlight = {
        enable = true,
        disable = function(_, bufnr) return bigfile(bufnr) end,
      },

      -- Treesitter indentation (Python is still iffy; disable there)
      indent = {
        enable = true,
        disable = { "python" },
      },

      -- Incremental selection (non-conflicting with flash.nvim)
      incremental_selection = {
        enable = true,
        keymaps = {
          -- Start or expand the selection
          init_selection = "<C-Space>",
          -- Grow to the next node
          node_incremental = "<C-Space>",
          -- Grow by scope (e.g., function/block)
          scope_incremental = "<C-s>",
          -- Shrink to the previous node
          node_decremental = "<BS>",
        },
      },

      -- Vim-matchup: TS-aware % motions and matches
      matchup = {
        enable = true,
      },

      -- Textobjects: select/move/swap using TS queries
      textobjects = {
        -- Selection textobjects (with lookahead)
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- Functions (outer/inner)
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            -- Classes (outer/inner) - using ]k/[k to avoid git hunk conflicts
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            -- Parameters/arguments (outer/inner)
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            -- Blocks/loops/conditionals (common nodes)
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
          },
        },
        -- Motions to next/prev function/class/parameter
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]k"] = "@class.outer",  -- Changed from ]c to avoid git hunk conflict
            ["]a"] = "@parameter.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[k"] = "@class.outer",  -- Changed from [c to avoid git hunk conflict
            ["[a"] = "@parameter.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]K"] = "@class.outer",  -- Changed from ]C to avoid git hunk conflict
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[K"] = "@class.outer",  -- Changed from [C to avoid git hunk conflict
          },
        },
        -- Swap parameters forward/backward (kept away from flash keys)
        swap = {
          enable = true,
          swap_next = {
            ["g>"] = "@parameter.inner",
          },
          swap_previous = {
            ["g<"] = "@parameter.inner",
          },
        },
      },

      -- Autotag: auto close/rename tags in web stacks
      autotag = {
        enable = true,
      },

      -- Context-aware commentstring is now handled separately (see config section)
    }
  end,

  -- Extra runtime configuration beyond configs.setup
  config = function(_, opts)
    -- Skip deprecated treesitter context_commentstring module integration
    vim.g.skip_ts_context_commentstring_module = true
    
    -- Apply core Treesitter modules
    require("nvim-treesitter.configs").setup(opts)
    
    -- Setup context_commentstring separately (new way)
    require('ts_context_commentstring').setup {
      enable_autocmd = false,
    }

    -- Treesitter folding (commented out - can be aggressive)
    -- vim.wo.foldmethod = "expr"
    -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    --
    -- -- Keep folds open on buffer read (nice default with context plugin)
    -- vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
    --   callback = function() pcall(vim.cmd.normal, "zR") end,
    -- })

    -- Configure the sticky context header (treesitter-context)
    require("treesitter-context").setup({
      enable = true,
      max_lines = 5,
      min_window_height = 10,
      line_numbers = true,
      multiline_threshold = 20,
      separator = nil,
      mode = "cursor",
    })

    -- Rainbow delimiters (commented out - can be visually aggressive)
    -- local rd = require("rainbow-delimiters")
    -- vim.g.rainbow_delimiters = {
    --   strategy = {
    --     [""] = rd.strategy["global"],
    --     commonlisp = rd.strategy["local"],
    --   },
    --   query = {
    --     [""] = "rainbow-delimiters",
    --     latex = "rainbow-blocks",
    --   },
    --   priority = {
    --     [""] = 110,
    --     lua = 210,
    --   },
    -- }

    -- Highlight arguments (good for Rust/Python/Lua)
    require("hlargs").setup({
      color = nil,          -- use colorscheme defaults (tokyonight-night ok)
      use_colorpalette = true,
      disable = function(_, bufnr)
        -- Share the bigfile guard for best performance
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        return ok and stats and stats.size and stats.size > 1.5 * 1024 * 1024
      end,
    })
  end,
}