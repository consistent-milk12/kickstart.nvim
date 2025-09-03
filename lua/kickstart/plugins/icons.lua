return {
  -- Modern, performant icon provider
  {
    'echasnovski/mini.icons',
    version = false,
    config = function()
      require('mini.icons').setup({
        -- Icon style: 'glyph' or 'ascii'
        style = 'glyph',
        -- Default icons for categories without specific icons
        default = {},
        -- Custom filetype icons
        filetype = {
          -- Add custom filetype icons here
          zsh = { glyph = '', hl = 'MiniIconsGreen' },
          log = { glyph = '', hl = 'MiniIconsYellow' },
        },
        -- Custom extension icons
        extension = {
          ['gitignore'] = { glyph = '', hl = 'MiniIconsOrange' },
        },
        -- Directory icons
        directory = {},
        -- LSP kind icons
        lsp = {},
      })
      
      -- Mock nvim-web-devicons for compatibility with other plugins
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },

  -- Keep nvim-web-devicons for full compatibility
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    opts = {
      -- Custom icons that complement mini.icons
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh"
        }
      },
      color_icons = true,
      default = true,
      strict = true,
      override_by_filename = {
        [".gitignore"] = {
          icon = "",
          color = "#f1502f",
          name = "Gitignore"
        }
      },
      override_by_extension = {
        ["log"] = {
          icon = "",
          color = "#81e043",
          name = "Log"
        }
      },
    },
  },
}