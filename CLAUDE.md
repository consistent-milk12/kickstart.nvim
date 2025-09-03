# CLAUDE.md - Comprehensive Config Reference

## Core Stack
- **Theme**: TokyoNight Night + comprehensive plugin highlights + nerd fonts
- **Completion**: Blink.cmp (Rust fuzzy) + LuaSnip + friendly-snippets
- **LSP**: Mason + lspconfig + enhanced capabilities integration
- **Search**: Telescope + fzf-native + undo/frecency extensions
- **Required**: Neovim 0.12+, ripgrep, fd, make, Nerd Font

## Plugin Architecture (45+ plugins)

### 🔍 **Search & Navigation**
- `telescope.nvim` - Fuzzy finder (files/grep/symbols/git/undo)
- `oil.nvim` - File management as buffers
- `flash.nvim` - Fast jump navigation with labels
- `undotree.nvim` - Visual undo history

### 💻 **LSP & Completion**
- `nvim-lspconfig` + `mason.nvim` - LSP server management
- `blink.cmp` - High-performance completion (0.5-4ms vs nvim-cmp's 60ms)
- `lazydev.nvim` - Lua development enhancements
- `conform.nvim` - Code formatting with Ruff/stylua integration

### 🎨 **UI & Visual**
- `tokyonight.nvim` - Modern colorscheme with extensive highlights
- `lualine.nvim` - Statusline with git/lsp integration
- `bufferline.nvim` - Buffer tabs with diagnostics
- `which-key.nvim` - Keymap discovery and documentation
- `noice.nvim` - Enhanced messages/cmdline/popupmenu UI
- `indent-blankline.nvim` - Visual indentation guides
- `nvim-colorizer.lua` - Inline color preview
- `vim-illuminate` - Highlight word under cursor

### 🔧 **Git Workflow**
- `gitsigns.nvim` - Git hunks in signcolumn + staging
- `neogit.nvim` - Modern git interface with conflict resolution
- `diffview.nvim` - Enhanced diff and merge views (via neogit)

### 🏗️ **Development**
- `nvim-treesitter` - Syntax highlighting + text objects
- `nvim-autopairs` - Smart bracket/quote pairing
- `nvim-surround` - Text object manipulation
- `Comment.nvim` - Smart commenting with treesitter
- `trouble.nvim` - Diagnostics and quickfix enhancement

### 🖥️ **Terminal & System**
- `toggleterm.nvim` - Floating/split terminals + REPL integration + seamless navigation
- `neoscroll.nvim` - Smooth scrolling animations
- `snacks.nvim` - Performance optimizations (bigfile/quickfile)

### 🧪 **Development Tools**
- `nvim-dap` + `nvim-dap-ui` - Debugging interface
- `nvim-lint` - Linting integration (disabled for markdown)
- `rustaceanvim` - Comprehensive Rust IDE with rust-analyzer integration

## Essential Keymaps

### **Search Operations** `<leader>s*`
- `sf/sg/sb` - Files/live-grep/buffers | `sh/sk/sc` - Help/keymaps/colors
- `su/s.` - Undo-tree/recent-files | `sn` - Neovim config | `/` - Buffer search

### **Git Operations** `<leader>g*` + `<leader>h*`
- `gg/gG` - Neogit status/float | `gc/gb/gs` - Commits/branches/status
- `hs/hr` - Stage/reset hunk | `hp/hd` - Preview/diff | `]c/[c` - Next/prev hunk

### **Code Operations** `<leader>c*`
- `cf` - Format buffer/selection | `cr/ct` - Run/test (language-aware)
- `cF/cI` - Toggle format-on-save/conform-info
- `grn/gra/grr` - Rename/action/references | `grd/gri` - Definition/implementation
- **Rust-specific**: `ca/co/cA` - Actions/organize/fix-all | `cR/cT/cd` - Advanced run/test/debug
- **Rust tools**: `ce/cm/cp/cD/cG/ci` - Explain/macro/parent/docs/graph/inlays

### **File Operations** `<leader>f*`
- `-` - Oil parent directory | `fe/fo` - Explorer root/reveal current
- `fz` - Zoxide directory jump

### **Buffer Management** `<leader>b*`
- `bd/bD` - Delete/delete-others | `bp/bn` - Previous/next
- `bP/br/bl` - Toggle-pin/close-right/close-left
- `<S-h>/<S-l>` - Navigate buffers | `]b/[b` - Next/prev buffer

### **Terminal Operations** `<leader>t*`
- `tf/th/tv/tt` - Float/horizontal/vertical/toggle terminal
- `tp/tn` - Python/Node REPL | `<C-\>` - Quick terminal toggle
- `tc/th` - Toggle completion/inlay-hints
- Terminal navigation: `<C-hjkl>` - Exit terminal & move to adjacent windows

### **UI & Diagnostics** `<leader>x*` + `<leader>n*`
- `xx/xX` - Diagnostics/buffer-diagnostics | `xs/xl` - Symbols/references
- `nl/nd/ns` - Last-message/dismiss/search | `]d/[d` - Next/prev diagnostic

### **Window Management** `<leader>w*`
- `wh/wv` - Horizontal/vertical split | `wc/wo` - Close/only
- `<C-hjkl>` - Navigate windows | `<C-arrows>` - Resize windows

## Protected Namespaces
**Reserved**: `<leader>s*` Search | `<leader>g/h*` Git | `<leader>f*` Files | `<leader>c*` Code
**System**: `<leader>b/w*` Buffers/Windows | `<leader>t*` Terminal/Toggle | `<leader>n/q/x*` UI/Quickfix/Diagnostics

## Performance Optimization
- **Startup**: <100ms cold start (45ms minimal, 85ms full development)
- **Lazy Loading**: Event-driven initialization + bigfile guards (1.5MB+)
- **Completion**: Rust fuzzy matcher + ghost text + cmdline integration
- **Smooth UX**: Neoscroll animations + snacks optimizations
- **Memory**: 40-80MB with LSP active, 100-200MB heavy editing

## Plugin Addition Workflow

### 1. **Research Phase**
```bash
# Check Plugin.md for recommendations
# Verify plugin compatibility and maintenance status
# Review plugin dependencies and conflicts
```

### 2. **Integration Steps**
```lua
-- 1. Create plugin file: /lua/plugins/plugin-name.lua
-- 2. Follow existing patterns:
return {
  'author/plugin-name',
  dependencies = { 'dep1', 'dep2' },
  event = 'VimEnter', -- or cmd/keys/ft for lazy loading
  keys = {
    { '<leader>xx', '<cmd>Command<cr>', desc = 'Description' },
  },
  config = function()
    require('plugin').setup({
      -- TokyoNight theming integration
      -- Performance optimizations
    })

    -- Apply TokyoNight highlights
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'tokyonight*',
      callback = function()
        -- Custom highlights here
      end,
    })
  end,
}
```

### 3. **Configuration Integration**
```lua
-- 3. Wire into init.lua
require 'plugins.plugin-name', -- description

-- 4. Update which-key.lua with new keymaps
{ '<leader>xx', desc = 'Plugin Action', icon = '' },
```

### 4. **Namespace Management**
- **Check conflicts**: Search existing keymaps with `rg "leader>x" *.lua`
- **Follow conventions**: Use protected namespaces appropriately
- **Document thoroughly**: Update which-key with proper icons and descriptions

### 5. **Quality Assurance**
```bash
# Test startup time
nvim --startuptime startup.log -c q

# Verify no conflicts
:checkhealth
:Lazy

# Test plugin functionality
# Update CLAUDE.md documentation
```

## Management Commands
- `:Lazy` - Plugin manager UI | `:Mason` - LSP tool installer
- `:checkhealth` - System diagnostics | `:ConformInfo` - Formatter status
- `:Telescope` - All pickers | `:Trouble` - Enhanced diagnostics
- `:Oil` - File management | `:UndotreeToggle` - Undo visualization
