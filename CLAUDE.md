# CLAUDE.md - Ultra-Compact Config Reference

**Kickstart.nvim** with advanced colorschemes, telescope, gitsigns, and undotree integration.

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

### Git (GitSigns)
- `]c/[c` - Next/prev hunk | `]C/[C` - Last/first hunk
- `<leader>hs/hr` - Stage/reset hunk | `<leader>hS/hR` - Stage/reset buffer
- `<leader>hp` - Preview hunk | `<leader>hb` - Blame line
- `<leader>hd` - Diff index | `<leader>hD` - Diff HEAD~1
- `<leader>tb` - Toggle blame | `<leader>ts` - Toggle signs

### Undotree
- `<leader>u` - Toggle undo tree | `j/k` - Navigate states | `q` - Close

### LSP  
- `grn` - Rename | `gra` - Code action | `grr` - References
- `grd` - Definition | `gri` - Implementation | `gO` - Symbols

### File Management (Oil.nvim)
- `-` - Open parent directory | `<leader>fe` - Float at project root
- `<leader>fE` - Float here | `<leader>o` - Toggle float | `<leader>fz` - Zoxide jump
- `<leader>fo` - Reveal current file | `<leader>fO` - Open CWD in Oil
- **In Oil**: `q` - Close | `r` - Refresh | `gd` - Toggle details | `yp/yP` - Copy path

## Plugin Files
- `colorscheme.lua` - TokyoNight Night + Kanagawa + Undotree integration
- `telescope.lua` - Advanced search with extensions (live_grep_args, frecency, undo, etc.)
- `gitsigns.lua` - Comprehensive git workflow with advanced keymaps
- `oil.lua` - Modern file explorer with git/LSP integration (replaces neo-tree)
- Main config in `init.lua` (~1000 lines)

## Advanced Features
- **Colorschemes**: Full TokyoNight integration with plugin-specific highlights
- **Telescope**: Live grep args, file browser, frecency, undo tree, DAP integration
- **GitSigns**: Visual staging, blame, diff views, quickfix integration, text objects
- **Oil**: LSP-aware file ops, git decorations, SSH support, trash integration
- **Undotree**: Persistent undo with TokyoNight styling and smart navigation
- **Performance**: Compilation, caching, lazy loading, startup <100ms target

## Management
- `:Lazy` - Plugin management | `:Mason` - LSP tools | `:checkhealth` - Diagnostics
- `:KanagawaCompile` - Compile colorscheme | `:UndotreeToggle` - Undo visualization