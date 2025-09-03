# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **kickstart.nvim** configuration - a single-file Neovim setup that serves as a starting point for personal customization. It's not a distribution but a documented foundation that users can read, understand, and modify to suit their needs.

## Key Architecture

### Core Components

- **Single-file configuration**: The main config is entirely contained in `init.lua` (~1017 lines)
- **Plugin management**: Uses `lazy.nvim` for plugin management with lazy loading
- **LSP integration**: Built-in Language Server Protocol support via `nvim-lspconfig`, Mason, and Blink
- **Modular plugin system**: Optional plugins in `lua/kickstart/plugins/` (commented out by default)
- **Custom extensions**: User plugins can be added via `lua/custom/plugins/`

### Plugin Architecture

The configuration follows a specific pattern:
1. Core Neovim options and keymaps are set first
2. `lazy.nvim` is bootstrapped and configured
3. Plugins are defined in a single table with dependencies properly structured
4. Each plugin configuration includes comprehensive comments explaining functionality

## Common Commands

### Neovim Management
- `nvim` - Start Neovim (will auto-install plugins on first run)
- `:Lazy` - View plugin status, update, or manage plugins
- `:Lazy update` - Update all plugins
- `:Mason` - Manage LSP servers, formatters, and linters
- `:checkhealth` - Run health checks for configuration issues
- `:checkhealth kickstart` - Run kickstart-specific health check

### Development Workflow
- `<space>sh` - Search help documentation (Telescope)
- `<space>sf` - Search files (Telescope)  
- `<space>sg` - Live grep search (Telescope)
- `<space>sn` - Search Neovim config files
- `<leader>f` - Format buffer using conform.nvim
- `:ConformInfo` - View formatter information

### LSP Commands
- `grn` - Rename symbol
- `gra` - Code action  
- `grr` - Find references
- `grd` - Go to definition
- `gri` - Go to implementation
- `grt` - Go to type definition
- `gO` - Document symbols
- `gW` - Workspace symbols

## Configuration Structure

### Core Files
- `init.lua` - Main configuration file containing all setup
- `lazy-lock.json` - Plugin version lockfile (should be tracked in git)
- `lua/kickstart/health.lua` - Health check utilities
- `lua/custom/plugins/init.lua` - User custom plugins (empty by default)

### Optional Plugins
Located in `lua/kickstart/plugins/` (uncommented to enable):
- `debug.lua` - DAP debugging setup
- `lint.lua` - Additional linting via nvim-lint  
- `autopairs.lua` - Automatic bracket pairing
- `neo-tree.lua` - File explorer
- `gitsigns.lua` - Enhanced git integration
- `indent_line.lua` - Indentation guides

### Key Design Principles

1. **Educational**: Every line is documented to help users learn
2. **Minimal**: Includes only essential plugins and functionality
3. **Self-contained**: Single file that's easy to understand and modify
4. **Extensible**: Clear patterns for adding new plugins and configurations
5. **Dependency management**: Uses Mason for automatic LSP/tool installation

## Customization Guidelines

### Adding New Plugins
Add plugins to the main `require('lazy').setup({})` table in `init.lua`, or create files in `lua/custom/plugins/` and uncomment the import line.

### LSP Configuration  
Edit the `servers` table in the LSP configuration section around line 673. Use Mason to automatically install servers.

### Keymaps
Custom keymaps should be added after the existing keymap sections, following the established patterns with descriptions.

### File Organization
- Keep the single-file approach initially for learning
- Consider splitting into modules only after understanding the full configuration
- Use `lua/custom/` for personal additions to avoid merge conflicts

## External Dependencies

### Required
- Neovim 0.10+ (stable or nightly)
- git, make, unzip, C compiler (gcc)
- ripgrep (rg) for telescope searching
- fd-find for improved file searching

### Optional  
- Nerd Font for icons (set `vim.g.have_nerd_font = true`)
- Clipboard tool (xclip/xsel/win32yank)
- Language-specific tools (npm for TypeScript, go for Golang, etc.)

## Health and Troubleshooting

- Run `:checkhealth` for comprehensive system diagnostics
- Use `:checkhealth kickstart` for configuration-specific checks
- Check Mason status with `:Mason` if LSP servers aren't working
- Verify external dependencies are installed and accessible