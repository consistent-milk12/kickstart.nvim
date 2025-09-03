# CLAUDE.md - Neovim Config Reference

## IMPORTANT PROJECT RULES

### No Icons or Emojis Policy
- NO emojis in code, comments, commit messages, or documentation
- NO icon characters or Unicode symbols for decorative purposes
- Nerd Font icons in UI plugins are acceptable for functional display
- This rule applies to ALL contributors and AI assistants

### AI Assistant Workflow - Practice Mode
**MANDATORY**: AI assistants must follow practice-focused workflow:
- NO direct file edits using Edit/Write/MultiEdit tools
- ONLY provide code snippets in terminal for manual typing practice
- User must build muscle memory by typing all code changes in Neovim
- **Exception 1**: Direct editing of .md files (documentation maintenance)
- **Exception 2**: Git operations for persistent project memory (commits/branching)
- **Exception 3**: Critical system fixes that prevent Neovim from functioning

## Core Stack
- **Theme**: TokyoNight Night + nerd fonts
- **Completion**: Blink.cmp (Rust fuzzy) + LuaSnip + friendly-snippets
- **LSP**: Mason + lspconfig + enhanced capabilities
- **Search**: Telescope + fzf-native + undo/frecency extensions
- **Required**: Neovim 0.12+, ripgrep, fd, make, Nerd Font

## Plugin Architecture (45+ plugins)
- **Search**: telescope.nvim, oil.nvim, flash.nvim, undotree.nvim
- **LSP**: nvim-lspconfig, mason.nvim, blink.cmp, lazydev.nvim, conform.nvim
- **UI**: tokyonight.nvim, lualine.nvim, bufferline.nvim, which-key.nvim, noice.nvim
- **Git**: gitsigns.nvim, neogit.nvim, diffview.nvim
- **Development**: nvim-treesitter (v1.x), nvim-autopairs, nvim-surround, Comment.nvim, trouble.nvim
- **Terminal**: toggleterm.nvim, neoscroll.nvim, snacks.nvim
- **Tools**: nvim-dap, nvim-lint, rustaceanvim

## Essential Keymaps
- **Search** `<leader>s*`: sf/sg/sb (files/grep/buffers), sn (config)
- **Git** `<leader>g/h*`: gg/gG (neogit), hs/hr (stage/reset), ]c/[c (hunks)
- **Code** `<leader>c*`: cf (format), cr/ct (run/test), grn/gra/grr (rename/action/refs)
- **Files** `<leader>f*`: - (oil), fe/fo (explorer), fz (zoxide)
- **Buffers** `<leader>b*`: bd/bD (delete/delete-others), bp/bn (prev/next)
- **Terminal** `<leader>t*`: tf/th/tv (float/horiz/vert), tp/tn (python/node)
- **UI** `<leader>x/n*`: xx (diagnostics), nl/nd (messages), ]d/[d (next/prev)
- **Windows** `<leader>w*`: wh/wv (split), <C-hjkl> (navigate), <C-arrows> (resize)

## Protected Namespaces
- **Reserved**: s* (Search), g/h* (Git), f* (Files), c* (Code)
- **System**: b/w* (Buffers/Windows), t* (Terminal), n/q/x* (UI/Diagnostics)

## Performance Optimization
- **Startup**: <100ms cold start, lazy loading + bigfile guards (1.5MB+)
- **Completion**: Rust fuzzy matcher + ghost text integration
- **Memory**: 40-80MB with LSP active, 100-200MB heavy editing

## Plugin Addition Workflow
1. **Research**: Check compatibility and maintenance status
2. **Create**: `/lua/plugins/plugin-name.lua` with lazy loading config
3. **Integrate**: Wire into `init.lua`, update `which-key.lua` keymaps
4. **Verify**: Check conflicts with `rg "leader>x" *.lua`, test with `:checkhealth`

## Management Commands
- `:Lazy` - Plugin manager | `:Mason` - LSP installer | `:ConformInfo` - Formatter status
- `:Telescope` - Pickers | `:Trouble` - Diagnostics | `:Oil` - File management

## Treesitter Architecture (v1.x)
**Migration**: Successfully migrated from legacy master to main branch (v1.x API rewrite)
- **Core**: Minimal parser management + native `vim.treesitter.*` integration
- **Highlighting**: FileType autocmds with `vim.treesitter.start(bufnr)`
- **Performance**: Big file detection (1.5MB) + lazy loading, <50ms startup impact

**Enhancement Status**:
- **Complete**: Syntax highlighting, parser management, context plugin
- **Missing**: Textobjects (needs restoration), incremental selection, code navigation
- **Roadmap**: Add aerial.nvim, restore af/if/ac/ic keymaps, enable folding

**Requirements**: Neovim 0.12+, tree-sitter CLI 0.25.0+, 23 essential parsers

## Git-Based Project Memory
**Purpose**: Persistent context preservation for AI assistants across sessions

**Commit Standards**: Include comprehensive context with architectural decisions, conflict resolutions, performance implications, and breaking changes. Always include Claude Code attribution.

**Context Reconstruction**:
1. `git log --oneline -10` - Recent changes
2. `git show --stat HEAD` - Last commit scope  
3. Review `CLAUDE.md` - Current architecture
4. `git status` - Working state
5. Use commit messages for decision rationale

**Memory Strategy**: Document "why" not just "what", track architecture evolution, record optimization notes, include migration guides for breaking changes.
