-- Enhanced autopairs with blink.cmp integration
return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  dependencies = { 'saghen/blink.cmp' },
  opts = {
    -- Disable default pairs for specific filetypes where they're problematic
    disable_filetype = { 'TelescopePrompt', 'vim' },
    -- Better handling of quotes in comments/strings
    enable_check_bracket_line = false,
    -- Smarter bracket insertion
    check_ts = true,
  },
  config = function(_, opts)
    local autopairs = require 'nvim-autopairs'
    autopairs.setup(opts)
    
    -- Integration with blink.cmp
    local ok, blink = pcall(require, 'blink.cmp')
    if ok then
      -- Setup completion integration
      blink.setup({
        keymap = {
          ['<CR>'] = {
            function(cmp)
              if cmp.is_visible() then
                return cmp.accept()
              else
                return autopairs.autopairs_cr()
              end
            end,
            'fallback'
          },
        },
      })
    end
  end,
}
