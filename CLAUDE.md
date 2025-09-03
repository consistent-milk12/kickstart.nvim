# CLAUDE.md - Ultra-Compact Config Reference

**Kickstart.nvim** with advanced colorschemes, telescope, git workflow, and modern file management.

## Core Setup
- **Theme**: TokyoNight Night (active) + Kanagawa Wave + advanced styling
- **Plugin Manager**: lazy.nvim with performance optimizations  
- **LSP**: Mason + nvim-lspconfig with Blink completion
- **Required**: Neovim 0.10+, ripgrep, fd, make, Nerd Font

## Key Bindings

### Search (Telescope)
- `<leader>sf` - Find files | `<leader>sg` - Live grep | `<leader>sb` - Buffers
- `<leader>sh` - Help | `<leader>sk` - Keymaps | `<leader>sc` - Colorschemes  
- `<leader>sr` - Resume | `<leader>s.` - Recent files | `<leader>su` - Undo tree
- `<leader>/` - Fuzzy search buffer | `<leader>sn` - Search Neovim config
- **In Telescope**: `Alt-o` - Reveal in Oil | `Alt-O` - Open directory in Oil

### Git (GitSigns + Neogit)
- `]c/[c` - Next/prev hunk | `]C/[C` - Last/first hunk
- `<leader>hs/hr` - Stage/reset hunk | `<leader>hS/hR` - Stage/reset buffer
- `<leader>hp` - Preview hunk | `<leader>hb` - Blame line
- `<leader>gg` - Neogit status | `<leader>gG` - Neogit float
- `<leader>gc` - Commit | `<leader>gp` - Push | `<leader>gP` - Pull

### Undotree + Window Management
- `<leader>u` - Toggle undo tree | `j/k` - Navigate states | `q` - Close
- `<leader>wh/wv` - Split horizontal/vertical | `<leader>wc/wo` - Close/only
- `<leader>bd/bn/bp` - Buffer delete/next/previous | `Ctrl+h/j/k/l` - Navigate windows

### LSP + File Management + Treesitter
- `grn` - Rename | `gra` - Code action | `grr` - References
- `grd` - Definition | `gri` - Implementation | `gO` - Symbols
- `-` - Open parent directory | `<leader>fo/fO` - Reveal file/Open CWD
- `<leader>fe/fE` - Float at root/here | **In Oil**: `q/r/gd/yp` - Close/refresh/details/copy

### Code Navigation (Treesitter + Flash)
- `]m/[m` - Next/prev function | `]k/[k` - Next/prev class | `]a/[a` - Next/prev parameter
- `]M/[M` - Function end | `]K/[K` - Class end | `g>/g<` - Swap parameters
- `<C-Space>` - Init/expand selection | `<C-s>` - Expand scope | `<BS>` - Shrink selection
- **Text objects**: `af/if` - Function | `ac/ic` - Class | `aa/ia` - Parameter | `al/il` - Loop
- **Flash**: `s` - Jump anywhere | `S` - Treesitter jump | `r` - Remote op | `Alt-f` - Toggle in search
- **Noice**: `<leader>nl/nh/nd/ns` - Last/history/dismiss/search messages | `Shift-Enter` - Redirect cmdline
- **Code ops**: `<leader>cf/cr/ct/cF/cI` - Format/Run/Test/Toggle-autosave/Info (Rust/Python/Lua)
- **Quickfix**: `<leader>qq/ql` - Toggle quickfix/location list (enhanced with Quicker.nvim)
- **Diagnostics**: `<leader>xx/xX/xs/xl` - Trouble diagnostics/buffer/symbols/LSP | Inline diagnostic display

## Reserved Keybinding Patterns
**PROTECTED** - Don't override these in future plugins:
- `<leader>s*` - Search (Telescope) | `<leader>h*` - Git hunks
- `<leader>g*` - Git operations | `<leader>f*` - File operations | `<leader>c*` - Code operations  
- `<leader>b*` - Buffers | `<leader>t*` - Toggles | `<leader>u` - Undotree | `<leader>w*` - Windows | `<leader>n*` - Noice | `<leader>q*` - Quickfix | `<leader>x*` - Diagnostics
- `]c/[c` - Hunk navigation | `]m/k/a/M/K` - Treesitter navigation
- `s/S/r/R` - Flash navigation | `gr*` - LSP operations | `g>/g<` - Parameter swap | `-` - Oil parent
- `Alt-o/O` - Telescope→Oil | `Alt-f` - Flash toggle | `Ctrl+h/j/k/l` - Window nav | `<C-Space>/s/BS` - TS selection

## Plugin Integration Rules
**ALL future plugins must:**
1. **Theme**: Add TokyoNight Night highlights in `colorscheme.lua`
2. **Keys**: Use available namespaces: `<leader>d*` (debug), `<leader>r*` (run/refactor)
3. **Which-key**: Document all keybindings in `which-key.lua` with icons
4. **Performance**: Lazy load with appropriate events/keys/cmd triggers
5. **Consistency**: Match existing UI patterns (floating windows, borders, etc.)

## Core Plugins
- `colorscheme.lua` - TokyoNight Night + comprehensive plugin highlights
- `telescope.lua` - Search engine + Oil integration + extensions
- `treesitter.lua` - Advanced syntax + textobjects + context + rainbow delimiters
- `noice.lua` - Enhanced cmdline/messages/notifications UI with nvim-notify
- `flash.lua` - Lightning-fast navigation with search labels  
- `gitsigns.lua` - Hunk management + visual git workflow
- `neogit.lua` - Modern git interface + commit/push workflow
- `oil.lua` - File explorer + LSP/git integration
- `which-key.lua` - Enhanced keybinding documentation + icons
- Main config: `init.lua` (~1000 lines) + window/buffer management

## Advanced Features
- **Colorschemes**: TokyoNight Night with plugin-specific highlights for all plugins
- **Telescope**: Live grep args, frecency, undo tree, Oil integration, DAP support
- **Treesitter**: Advanced parsing (rust, python, json+), textobjects, context headers, rainbow brackets, argument highlighting, bigfile protection
- **UI Enhancement**: Noice cmdline popup, nvim-notify integration, LSP progress/hover, message filtering, Telescope integration
- **Git Workflow**: GitSigns staging → Neogit commit/push → Telescope history
- **File Management**: Oil buffer-style editing + git decorations + SSH support
- **Performance**: Compilation, caching, lazy loading, startup <100ms target

## Management
- `:Lazy` - Plugin management | `:Mason` - LSP tools | `:checkhealth` - Diagnostics
- `:KanagawaCompile` - Compile colorscheme | **Available namespaces**: `<leader>d/r/w*`