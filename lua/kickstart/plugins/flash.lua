-- Flash.nvim: Fast navigation with search labels and enhanced f/t/F/T motions
-- Integrates with TokyoNight Night theme and respects existing keybinding conflicts

return {
  -- Use the official repo
  "folke/flash.nvim",

  -- Load after core UI is up, as per upstream examples
  event = "VeryLazy",

  -- Keymaps (functions to preserve dot-repeat; per README)
  keys = {
    -- Standalone jump: label-based hop anywhere
    { "s", mode = { "n", "x", "o" },
      function() require("flash").jump() end,
      desc = "Flash Jump" },

    -- Treesitter-aware target selection
    { "S", mode = { "n", "x", "o" },
      function() require("flash").treesitter() end,
      desc = "Flash Treesitter" },

    -- Operator-pending remote action (e.g., `yr` to yank there)
    { "r", mode = "o",
      function() require("flash").remote() end,
      desc = "Flash Remote (operator)" },

    -- Treesitter search as an operator/visual (e.g., `yR`)
    { "R", mode = { "o", "x" },
      function() require("flash").treesitter_search() end,
      desc = "Flash Treesitter Search" },

    -- Toggle Flash during `/` or `?` searches (changed from <C-s> to avoid conflicts)
    { "<A-f>", mode = { "c" },
      function() require("flash").toggle() end,
      desc = "Toggle Flash in Search" },
  },

  -- Configuration options
  opts = function()
    -- Home-row label alphabet for fast targeting
    local labels = "asdfghjklqwertyuiopzxcvbnm"

    -- Exclude non-focusable windows & common UIs (per README)
    local exclude = {
      "notify", "cmp_menu", "noice", "flash_prompt",
      function(win)
        return not vim.api.nvim_win_get_config(win).focusable
      end,
    }

    -- Return full Flash config
    return {
      -- Label characters to render at candidate locations
      labels = labels,

      -- Plain-text jump/search behavior
      search = {
        -- Consider all windows by default
        multi_window = true,
        -- Wrap around the buffer when reaching end
        wrap = true,
        -- Use literal/exact matching by default
        mode = "exact",
        -- Don't shadow incsearch; keep explicit
        incremental = false,
        -- Skip noisy/aux windows
        exclude = exclude,
      },

      -- Jump behavior tuning
      jump = {
        -- Record in jumplist for easy return
        jumplist = true,
        -- Land at the start of the match
        pos = "start",
        -- If only one match exists, go there automatically
        autojump = true,
        -- Leave search highlights intact
        nohlsearch = false,
      },

      -- Label rendering options
      label = {
        -- Allow upper-case labels if needed
        uppercase = true,
        -- Always label the first match in current window
        current = true,
        -- Put labels after the match (comfortable reading flow)
        after = true,
        -- Overlay labels on top of text
        style = "overlay",
        -- Prefer nearer labels in current window
        distance = true,
        -- Show labels even for short patterns
        min_pattern_length = 0,
      },

      -- Per-mode overrides (search/char/…)
      modes = {
        -- Live search integration: keep opt-in (toggle with <A-f>)
        search = {
          -- Off by default to avoid surprising novices
          enabled = false,
          -- Don't dim the backdrop while searching
          highlight = { backdrop = false },
          -- Make jumps feel like native search
          jump = {
            history = true, 
            register = true, 
            nohlsearch = true,
          },
        },

        -- Enhanced `f/t/F/T` motions (labels on demand)
        char = {
          -- Turn on enhanced single-char motions
          enabled = true,
          -- Keep hints visible after motion unless labels are used
          autohide = false,
          -- Show jump labels (smartly suppressed for counts/macros)
          jump_labels = true,
          -- Allow crossing line boundaries
          multi_line = true,
          -- Don't steal these keys immediately after a motion
          label = { exclude = "hjkliardc" },
          -- Keys to enhance: ftFT plus ; and ,
          keys = { "f", "F", "t", "T", ";", "," },
          -- Upstream smart gating (don't label when counting/recording)
          config = function(opts)
            opts.jump_labels = opts.jump_labels
              and vim.v.count == 0
              and vim.fn.reg_executing() == ""
              and vim.fn.reg_recording() == ""
          end,
        },
      },

      -- Highlight groups (names exist; scheme supplies colors)
      highlight = {
        -- Keep subtle backdrop; good contrast in TokyoNight
        backdrop = true,
        -- Emphasize matches
        matches = true,
        -- Use standard groups; scheme can override links
        groups = {
          match = "FlashMatch",
          current = "FlashCurrent",
          backdrop = "FlashBackdrop",
          label = "FlashLabel",
        },
      },
    }
  end,

  -- Final setup & TokyoNight Night theme integration
  config = function(_, opts)
    -- Initialize plugin with computed options
    require("flash").setup(opts)

    -- TokyoNight Night theme integration
    local aug = vim.api.nvim_create_augroup("FlashHi", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      -- Run whenever colorscheme changes
      group = aug,
      -- Keep this defensive and minimal
      callback = function()
        -- Only touch when using TokyoNight variants
        local name = vim.g.colors_name or ""
        if name:find("tokyonight") then
          -- Match → Search (already styled by scheme)
          vim.api.nvim_set_hl(0, "FlashMatch", { link = "Search" })
          -- Current match → IncSearch for extra pop
          vim.api.nvim_set_hl(0, "FlashCurrent", { link = "IncSearch" })
          -- Backdrop → Comment (dim)
          vim.api.nvim_set_hl(0, "FlashBackdrop", { link = "Comment" })
          -- Labels → Substitute (high-contrast label chips)
          vim.api.nvim_set_hl(0, "FlashLabel", { link = "Substitute" })
        end
      end,
      desc = "Flash: align highlights with TokyoNight",
    })
  end,
}