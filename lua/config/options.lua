-- Leader keys (must be first)
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font available in terminal
vim.g.have_nerd_font = true

-- [[ Core Options ]]
-- See `:help vim.opt` for modern Lua interface
-- NOTE: You can change these options as you wish!

-- UI & Colors
vim.opt.termguicolors = true  -- Enable 24-bit colors for proper theme rendering
vim.opt.number = true         -- Line numbers
-- vim.opt.relativenumber = true  -- Relative line numbers for easier jumping

-- Mouse support for resizing splits, etc.
vim.opt.mouse = 'a'

-- Hide mode since it's in statusline
vim.opt.showmode = false

-- Clipboard: sync with OS, scheduled for performance, skip over SSH
-- See `:help 'clipboard'`
vim.schedule(function()
  if vim.env.SSH_TTY then
    vim.opt.clipboard = '' -- Avoid remote clipboard slowness/hangs
  else
    vim.opt.clipboard = 'unnamedplus'
  end
end)

-- Editing & Text Formatting
vim.opt.breakindent = true    -- Wrap preserves indentation
vim.opt.undofile = true       -- Persistent undo history

-- Search behavior
vim.opt.ignorecase = true     -- Case-insensitive by default
vim.opt.smartcase = true      -- Case-sensitive if uppercase present

-- UI Elements  
vim.opt.signcolumn = 'yes'    -- Always show sign column
vim.opt.cursorline = true     -- Highlight cursor line
vim.opt.cursorlineopt = 'number'  -- Only highlight line number (less noisy)

-- Scrolling & Navigation
vim.opt.scrolloff = 10        -- Keep lines above/below cursor
vim.opt.sidescrolloff = 8     -- Keep columns left/right of cursor
vim.opt.smoothscroll = true   -- Screen-line scrolling for wrapped text (0.10+)

-- Performance & Timing
vim.opt.updatetime = 250      -- Faster updates for better UX
vim.opt.timeoutlen = 300      -- Mapping timeout
vim.opt.ttimeout = true       -- Enable keycode timeout
vim.opt.ttimeoutlen = 50      -- Snappy escape key response

-- Splits & Windows
vim.opt.splitright = true    -- Vertical splits go right
vim.opt.splitbelow = true    -- Horizontal splits go below  
vim.opt.splitkeep = 'screen' -- Reduce content shift on split (0.9+)

-- Command Line & Messages (optimized for Noice.nvim)
vim.opt.cmdheight = 0            -- Hide command line, let Noice handle it
vim.opt.showcmdloc = 'statusline' -- Show partial commands in statusline
vim.opt.shortmess:append({
  I = true,  -- No intro message
  W = true,  -- Don't show "written" messages
  C = true,  -- Don't show ins-completion messages  
  s = true,  -- Don't show search hit messages
})

-- Whitespace Visualization
-- See `:help 'listchars'` - using vim.opt for table interface
vim.opt.list = true
vim.opt.listchars = {
  tab = '» ',
  trail = '·', 
  nbsp = '␣',
  extends = '›',
  precedes = '‹',
}

-- Live substitute preview
vim.opt.inccommand = 'split'

-- Popup & Float Polish
vim.opt.pumblend = 10        -- Subtle transparency for completion menu
vim.opt.winblend = 0         -- Keep normal floats opaque for readability

-- Fill Characters (cleaner appearance)
vim.opt.fillchars:append({
  eob = ' ',     -- No ~ at end of buffer
  diff = '╱',    -- Cleaner diff filler
})

-- Command Line Completion
vim.opt.wildmode = 'longest:full,full'  -- Better completion behavior
vim.opt.wildoptions = 'pum,fuzzy'       -- Popup menu with fuzzy matching (0.9+)

-- Window Title (useful in tmux/terminal multiplexers)
vim.opt.title = true
vim.opt.titlestring = 'nvim — %f'

-- Confirm dialog for unsaved changes
vim.opt.confirm = true

