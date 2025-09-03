return {
  -- TokyoNight Night Theme - Advanced Configuration
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        -- Theme variant - Night only (darkest variant)
        style = 'night',
        light_style = 'night', -- Use night for both modes

        -- Performance Options
        cache = true, -- Enable caching for better performance
        terminal_colors = true, -- Configure terminal colors

        -- Text Styling Options
        styles = {
          comments = { italic = true },
          keywords = { italic = true, bold = true },
          functions = { bold = true },
          variables = {},
          -- Background styles for UI elements
          sidebars = 'dark', -- dark, transparent, normal
          floats = 'dark',
        },

        -- Visual Options
        transparent = false, -- Keep solid background
        day_brightness = 0.3, -- Brightness adjustment
        dim_inactive = false, -- Don't dim inactive windows
        lualine_bold = true, -- Bold lualine headers

        -- Advanced Color Customization
        on_colors = function(colors)
          -- Custom night variant enhancements
          colors.bg_highlight = '#292e42'
          colors.bg_visual = '#283457'
          colors.border_highlight = '#27a1b9'
        end,

        -- Advanced Override Functions
        on_highlights = function(hl, colors)
          -- Enhanced syntax highlighting
          hl.String = { fg = colors.green, italic = true }
          hl.Number = { fg = colors.orange, bold = true }
          hl.Boolean = { fg = colors.orange, bold = true }
          hl.Constant = { fg = colors.magenta }

          -- Improved diagnostics with subtle backgrounds
          local function make_diagnostic_bg(color)
            return vim.fn.printf(
              '#%06x',
              bit.bor(
                bit.lshift(math.floor(tonumber(color:sub(2, 3), 16) * 0.1), 16),
                bit.bor(bit.lshift(math.floor(tonumber(color:sub(4, 5), 16) * 0.1), 8), math.floor(tonumber(color:sub(6, 7), 16) * 0.1))
              )
            )
          end

          hl.DiagnosticVirtualTextError = {
            fg = colors.error,
            bg = colors.bg_dark,
          }
          hl.DiagnosticVirtualTextWarn = {
            fg = colors.warning,
            bg = colors.bg_dark,
          }
          hl.DiagnosticVirtualTextInfo = {
            fg = colors.info,
            bg = colors.bg_dark,
          }
          hl.DiagnosticVirtualTextHint = {
            fg = colors.hint,
            bg = colors.bg_dark,
          }

          -- Enhanced Telescope integration
          local prompt = '#2d3149'
          hl.TelescopeNormal = { bg = colors.bg_dark, fg = colors.fg_dark }
          hl.TelescopeBorder = { bg = colors.bg_dark, fg = colors.bg_dark }
          hl.TelescopePromptNormal = { bg = prompt }
          hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
          hl.TelescopePromptTitle = { bg = colors.blue, fg = colors.bg, bold = true }
          hl.TelescopePreviewTitle = { bg = colors.green, fg = colors.bg, bold = true }
          hl.TelescopeResultsTitle = { bg = colors.purple, fg = colors.bg, bold = true }

          -- Oil-Telescope integration highlights
          -- File type indicators in Telescope results
          hl.TelescopeResultsFileIcon = { fg = colors.blue }
          hl.TelescopeResultsFileName = { fg = colors.fg }
          hl.TelescopeResultsLineNr = { fg = colors.orange }
          hl.TelescopeResultsPath = { fg = colors.comment }
          
          -- Oil reveal indicators and feedback
          hl.TelescopeResultsIdentifier = { fg = colors.cyan }
          hl.TelescopeResultsOperator = { fg = colors.orange }
          hl.TelescopeResultsComment = { fg = colors.comment, italic = true }
          
          -- Enhanced selection highlighting for Oil integration
          hl.TelescopeSelection = { bg = colors.bg_highlight, fg = colors.fg, bold = true }
          hl.TelescopeSelectionCaret = { fg = colors.orange, bg = colors.bg_highlight, bold = true }
          hl.TelescopeMultiSelection = { bg = colors.bg_visual, fg = colors.yellow }
          hl.TelescopeMultiIcon = { fg = colors.green, bold = true }
          
          -- Oil integration action hints
          hl.TelescopeActionHint = { fg = colors.blue, italic = true }
          hl.TelescopeActionKey = { fg = colors.green, bold = true }
          hl.TelescopeActionDescription = { fg = colors.fg_dark }
          
          -- Directory breadcrumb in Telescope
          hl.TelescopePathBreadcrumb = { fg = colors.blue, bold = true }
          hl.TelescopePathSeparator = { fg = colors.comment }
          
          -- Git status in Telescope file results  
          hl.TelescopeResultsGitAdd = { fg = colors.git.add }
          hl.TelescopeResultsGitChange = { fg = colors.git.change }
          hl.TelescopeResultsGitDelete = { fg = colors.git.delete }
          hl.TelescopeResultsGitStaged = { fg = colors.green }
          hl.TelescopeResultsGitUntracked = { fg = colors.yellow }
          
          -- Oil reveal success/error feedback
          hl.TelescopeResultsSuccess = { fg = colors.green, bold = true }
          hl.TelescopeResultsError = { fg = colors.error, bold = true }
          hl.TelescopeResultsWarning = { fg = colors.warning }

          -- Enhanced completion menu
          hl.Pmenu = { fg = colors.fg, bg = colors.bg_popup }
          hl.PmenuSel = { bg = colors.bg_highlight }
          hl.PmenuSbar = { bg = colors.bg_popup }
          hl.PmenuThumb = { bg = colors.fg_gutter }

          -- Better indentation guides
          hl.IblIndent = { fg = colors.bg_highlight }
          hl.IblScope = { fg = colors.purple }

          -- Enhanced git signs
          hl.GitSignsAdd = { fg = colors.git.add }
          hl.GitSignsChange = { fg = colors.git.change }
          hl.GitSignsDelete = { fg = colors.git.delete }

          -- Better LSP references
          hl.LspReferenceText = { bg = colors.bg_highlight }
          hl.LspReferenceRead = { bg = colors.bg_highlight }
          hl.LspReferenceWrite = { bg = colors.bg_highlight }

          -- Enhanced which-key
          hl.WhichKey = { fg = colors.cyan }
          hl.WhichKeyGroup = { fg = colors.blue }
          hl.WhichKeyDesc = { fg = colors.fg_dark }
          hl.WhichKeySeperator = { fg = colors.comment }
          hl.WhichKeyFloat = { bg = colors.bg_dark }

          -- Better trouble.nvim integration
          hl.TroubleText = { fg = colors.fg_dark }
          hl.TroubleCount = { fg = colors.purple, bg = colors.bg_statusline }
          hl.TroubleNormal = { fg = colors.fg, bg = colors.bg_sidebar }

          -- Enhanced line numbers
          hl.LineNr = { fg = colors.fg_gutter }
          hl.CursorLineNr = { fg = colors.orange, bold = true }

          -- Better search highlighting
          hl.Search = { bg = colors.bg_search, fg = colors.fg }
          hl.IncSearch = { bg = colors.orange, fg = colors.bg }

          -- Enhanced fold styling
          hl.Folded = { fg = colors.blue, bg = colors.bg_highlight }
          hl.FoldColumn = { fg = colors.comment, bg = colors.bg }

          -- Better cursor line
          hl.CursorLine = { bg = colors.bg_highlight }
          hl.ColorColumn = { bg = colors.bg_highlight }

          -- Enhanced matching parentheses
          hl.MatchParen = { fg = colors.orange, bold = true }

          -- Better visual selection
          hl.Visual = { bg = colors.bg_visual }
          hl.VisualNOS = { bg = colors.bg_visual }

          -- Enhanced undotree integration
          hl.UndotreeNode = { fg = colors.fg_dark }
          hl.UndotreeNodeCurrent = { fg = colors.orange, bold = true }
          hl.UndotreeSeq = { fg = colors.blue }
          hl.UndotreeNext = { fg = colors.green, bold = true }
          hl.UndotreeTimeStamp = { fg = colors.comment, italic = true }
          hl.UndotreeBranch = { fg = colors.purple }
          hl.UndotreeHead = { fg = colors.cyan, bold = true }
          hl.UndotreeSavedBig = { fg = colors.red, bold = true }
          hl.UndotreeSavedSmall = { fg = colors.yellow }

          -- Enhanced Oil.nvim integration with TokyoNight Night theme
          -- File and directory styling
          hl.OilDir = { fg = colors.blue, bold = true }
          hl.OilDirIcon = { fg = colors.blue }
          hl.OilFile = { fg = colors.fg }
          hl.OilFileHidden = { fg = colors.fg_dark }
          hl.OilTypeDir = { fg = colors.blue, bold = true }
          hl.OilTypeFile = { fg = colors.fg }
          hl.OilTypeLink = { fg = colors.cyan, italic = true }
          
          -- Oil operations and changes
          hl.OilSocket = { fg = colors.purple }
          hl.OilCreate = { fg = colors.green, bold = true }
          hl.OilDelete = { fg = colors.red, bold = true }
          hl.OilMove = { fg = colors.yellow, bold = true }
          hl.OilCopy = { fg = colors.orange, bold = true }
          hl.OilChange = { fg = colors.blue, bold = true }
          
          -- Oil detailed view (permissions, size, time)
          hl.OilPermissionNone = { fg = colors.comment }
          hl.OilPermissionRead = { fg = colors.yellow }
          hl.OilPermissionWrite = { fg = colors.orange }
          hl.OilPermissionExecute = { fg = colors.green }
          hl.OilSize = { fg = colors.cyan }
          hl.OilMtime = { fg = colors.purple, italic = true }
          
          -- Oil git decorations (matching your GitSigns theme)
          hl.OilGitAdd = { fg = colors.git.add }
          hl.OilGitModify = { fg = colors.git.change }
          hl.OilGitRename = { fg = colors.git.change }
          hl.OilGitDelete = { fg = colors.git.delete }
          hl.OilGitIgnore = { fg = colors.comment }
          hl.OilGitUntracked = { fg = colors.yellow }
          hl.OilGitStaged = { fg = colors.green }
          hl.OilGitConflict = { fg = colors.red, bold = true }
          
          -- Oil LSP diagnostics integration
          hl.OilLspError = { fg = colors.error }
          hl.OilLspWarn = { fg = colors.warning }
          hl.OilLspInfo = { fg = colors.info }
          hl.OilLspHint = { fg = colors.hint }
          
          -- Oil special files and states
          hl.OilTrash = { fg = colors.comment, italic = true }
          hl.OilRestore = { fg = colors.green }
          hl.OilLink = { fg = colors.cyan, italic = true }
          hl.OilLinkTarget = { fg = colors.blue }
          
          -- Oil UI elements
          hl.OilCursor = { bg = colors.bg_highlight }
          hl.OilCursorLine = { bg = colors.bg_highlight }
          hl.OilVirtualText = { fg = colors.comment, italic = true }
          
          -- Oil floating window integration
          hl.OilFloat = { bg = colors.bg_float, fg = colors.fg }
          hl.OilFloatBorder = { fg = colors.border_highlight, bg = colors.bg_float }
          hl.OilFloatTitle = { fg = colors.blue, bg = colors.bg_float, bold = true }
          
          -- Oil SSH support styling
          hl.OilSSH = { fg = colors.magenta, italic = true }
          hl.OilSSHDir = { fg = colors.magenta, bold = true }
          hl.OilSSHFile = { fg = colors.fg_dark }

          -- Oil column headers and borders
          hl.OilColumnHeader = { fg = colors.blue, bold = true, bg = colors.bg_statusline }
          hl.OilColumnBorder = { fg = colors.border }
          
          -- Oil entry selection and highlighting
          hl.OilEntry = { fg = colors.fg }
          hl.OilEntrySelected = { bg = colors.bg_visual, fg = colors.fg }
          hl.OilEntryHidden = { fg = colors.comment }
          
          -- Oil preview window
          hl.OilPreview = { bg = colors.bg_dark }
          hl.OilPreviewBorder = { fg = colors.border, bg = colors.bg_dark }
        end,

        -- Plugin integration
        plugins = {
          auto = true, -- Auto-detect plugins
          all = false, -- Don't enable all plugins by default
        },
      }

      -- Uncomment to use TokyoNight instead of Kanagawa
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
}
