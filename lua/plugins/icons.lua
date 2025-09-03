return {
  -- Modern, performant icon provider (2025 standard)
  {
    'echasnovski/mini.icons',
    version = false,
    config = function()
      require('mini.icons').setup {
        -- Icon style: 'glyph' or 'ascii'
        style = 'glyph',
        -- Default icons for categories without specific icons
        default = {},
        -- Custom filetype icons
        filetype = {
          zsh = { glyph = '', hl = 'MiniIconsGreen' },
          log = { glyph = '', hl = 'MiniIconsYellow' },
        },
        -- Custom extension icons
        extension = {
          gitignore = { glyph = '', hl = 'MiniIconsOrange' },
          log = { glyph = '', hl = 'MiniIconsYellow' },
        },
        -- Custom filename icons
        file = {
          ['.gitignore'] = { glyph = '', hl = 'MiniIconsOrange' },
          ['dockerfile'] = { glyph = '', hl = 'MiniIconsBlue' },
          ['makefile'] = { glyph = '', hl = 'MiniIconsGreen' },
        },
        -- Directory icons
        directory = {},
        -- LSP kind icons for completions
        lsp = {},
      }

      -- Mock nvim-web-devicons for full backward compatibility
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },
}

