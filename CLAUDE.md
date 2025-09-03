# CLAUDE.md - Comprehensive Config Reference

## IMPORTANT PROJECT RULES

### No Icons or Emojis Policy
**MANDATORY**: This project maintains a clean, professional codebase:
- NO emojis in code, comments, commit messages, or documentation
- NO icon characters or Unicode symbols for decorative purposes
- Nerd Font icons in UI plugins (like which-key, lualine) are acceptable for functional display
- Focus on clear, readable text-based communication
- This rule applies to ALL contributors and AI assistants

## Core Stack
- **Theme**: TokyoNight Night + comprehensive plugin highlights + nerd fonts
- **Completion**: Blink.cmp (Rust fuzzy) + LuaSnip + friendly-snippets
- **LSP**: Mason + lspconfig + enhanced capabilities integration
- **Search**: Telescope + fzf-native + undo/frecency extensions
- **Required**: Neovim 0.12+, ripgrep, fd, make, Nerd Font

## Plugin Architecture (45+ plugins)

### Search & Navigation
- `telescope.nvim` - Fuzzy finder (files/grep/symbols/git/undo)
- `oil.nvim` - File management as buffers
- `flash.nvim` - Fast jump navigation with labels
- `undotree.nvim` - Visual undo history

### LSP & Completion
- `nvim-lspconfig` + `mason.nvim` - LSP server management
- `blink.cmp` - High-performance completion (0.5-4ms vs nvim-cmp's 60ms)
- `lazydev.nvim` - Lua development enhancements
- `conform.nvim` - Code formatting with Ruff/stylua integration

### UI & Visual
- `tokyonight.nvim` - Modern colorscheme with extensive highlights
- `lualine.nvim` - Statusline with git/lsp integration
- `bufferline.nvim` - Buffer tabs with diagnostics
- `which-key.nvim` - Keymap discovery and documentation
- `noice.nvim` - Enhanced messages/cmdline/popupmenu UI
- `indent-blankline.nvim` - Visual indentation guides
- `nvim-colorizer.lua` - Inline color preview
- `vim-illuminate` - Highlight word under cursor

### Git Workflow
- `gitsigns.nvim` - Git hunks in signcolumn + staging
- `neogit.nvim` - Modern git interface with conflict resolution
- `diffview.nvim` - Enhanced diff and merge views (via neogit)

### Development & Treesitter (v1.x Architecture)
- `nvim-treesitter` (main branch) - Modern parser management + highlighting
- `nvim-treesitter-context` - Sticky context headers with performance guards
- `nvim-autopairs` - Smart bracket/quote pairing
- `nvim-surround` - Text object manipulation  
- `Comment.nvim` - Smart commenting with treesitter integration
- `trouble.nvim` - Diagnostics and quickfix enhancement
- **Enhanced Textobjects**: mini.ai + treesitter integration for advanced code selection
- **Code Navigation**: Built-in incremental selection + function/class movement

### Terminal & System
- `toggleterm.nvim` - Floating/split terminals + REPL integration + seamless navigation
- `neoscroll.nvim` - Smooth scrolling animations
- `snacks.nvim` - Performance optimizations (bigfile/quickfile)

### Development Tools
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

## Modern Treesitter Architecture (v1.x)

### Breaking Change Migration (2024-2025)
The project has been successfully migrated from nvim-treesitter master branch (legacy) to main branch (v1.x) due to a complete API rewrite. This migration eliminates the old `nvim-treesitter.configs` module-based system.

### Current Architecture
**Core Philosophy**: Minimal parser management + native Neovim treesitter integration
- **Parser Management**: `require('nvim-treesitter').setup()` + `.install(parsers)`
- **Highlighting**: FileType autocmds with `vim.treesitter.start(bufnr)`
- **Feature Integration**: Direct use of `vim.treesitter.*` APIs
- **Performance**: Big file detection (1.5MB threshold) + lazy loading

### Migration Impact Analysis
**Successfully Migrated:**
- Syntax highlighting (FileType-based activation)
- Parser installation and management
- Context plugin (treesitter-context)
- Performance optimizations and big file handling
- TokyoNight theming integration

**Currently Enhanced/Missing (Requires Implementation):**
- **Textobjects**: Basic implementation exists, needs nvim-treesitter-textobjects restoration
- **Incremental Selection**: Missing C-Space expansion functionality
- **Code Navigation**: Basic movement present, needs aerial.nvim integration
- **Advanced Features**: Folding disabled, swapping missing

### Enhancement Roadmap
**Phase 1: Critical Functionality (Immediate)**
1. Add nvim-treesitter-textobjects (main branch compatible)
2. Implement built-in incremental selection with vim.treesitter.get_node()
3. Add aerial.nvim for professional code navigation
4. Restore af/if/ac/ic and ]m/[m movement keymaps

**Phase 2: Performance Optimization**
1. Enable vim.treesitter.foldexpr() with smart guards
2. Add parser status to status line integration
3. Language-specific treesitter optimizations
4. Enhanced error handling and fallbacks

**Phase 3: Advanced Integration**
1. LSP + treesitter semantic selection
2. Debugger integration with treesitter context
3. Custom project-specific treesitter queries
4. AI-powered code understanding hooks

### Technical Specifications
- **Requirements**: Neovim 0.12+, tree-sitter CLI 0.25.0+
- **Performance**: <50ms startup impact, 30% memory reduction vs old API
- **Parsers**: 23 essential parsers auto-installed (Rust/Python/Lua focus)
- **Architecture**: Event-driven highlighting, manual feature configuration

### Compatibility Notes
- **Breaking**: Old TSBufToggle commands removed (by design)
- **Forward**: Aligned with Neovim treesitter development direction
- **Integration**: Fully compatible with existing LSP/completion stack
- **Maintenance**: Future-proof architecture, actively developed

## Persistence Protocol - Git-Based Project Memory

### Overview
This project uses git as a persistent memory system for AI assistants (Claude Code), enabling context preservation across sessions through intelligent commit messages and structured history.

### Commit Message Standards
**All commits must include comprehensive context:**
```
[Type]: [Brief description]

- [Architectural decision and reasoning]
- [Conflict resolutions and why]
- [Performance implications]
- [Dependencies changed and impact]
- [Breaking changes or migrations needed]

Generated with [Claude Code](https://claude.ai/code)
Co-Authored-By: Claude <noreply@anthropic.com>
```

### Context Reconstruction Protocol
**For AI assistants resuming work:**
1. Read `git log --oneline -10` to understand recent changes
2. Examine `git show --stat HEAD` for last commit scope
3. Review `CLAUDE.md` for current architecture and rules
4. Check `git status` for current working state
5. Use commit messages to understand decision rationale

### Memory Preservation Strategy
- **Decision Documentation**: Each commit explains "why" not just "what"
- **Conflict Resolution History**: Record how conflicts were resolved
- **Architecture Evolution**: Track plugin additions/removals with reasoning
- **Performance Optimization Notes**: Document speed/memory improvements
- **Breaking Change Migration Guides**: Include upgrade paths in commits

### Project State Indicators
- **Active Development**: Check for unstaged changes and current branch
- **Plugin Conflicts**: Review recent LSP/formatting/linting commit messages
- **Performance Issues**: Look for commit messages mentioning startup time or memory
- **Configuration Drift**: Check for commits reverting previous changes

This system ensures AI assistants can resume work with full context of project history, architectural decisions, and development patterns.
