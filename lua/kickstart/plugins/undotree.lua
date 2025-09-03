-- Undotree: Visual undo history with TokyoNight theming
-- Provides a visual tree of all changes with timestamps and navigation
return {
  'mbbill/undotree',
  cmd = 'UndotreeToggle',
  keys = {
    { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = '󰕌 Undo Tree' },
  },
  config = function()
    -- Undotree configuration
    vim.g.undotree_WindowLayout = 2 -- Right side layout
    vim.g.undotree_SplitWidth = 40 -- Reasonable width
    vim.g.undotree_SetFocusWhenToggle = 1 -- Focus on toggle
    vim.g.undotree_ShortIndicators = 1 -- Short time indicators
    vim.g.undotree_HighlightChangedText = 1 -- Highlight changes
    vim.g.undotree_HighlightSyntaxAdd = '#98bb6c' -- TokyoNight green
    vim.g.undotree_HighlightSyntaxChange = '#e0af68' -- TokyoNight yellow
    vim.g.undotree_HighlightSyntaxDelete = '#f7768e' -- TokyoNight red
    
    -- Better diff window settings
    vim.g.undotree_DiffpanelHeight = 12
    vim.g.undotree_DiffAutoOpen = 1
    
    -- Apply TokyoNight highlights when colorscheme loads
    -- (Highlights are already defined in colorscheme.lua)
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'tokyonight*',
      callback = function()
        -- Force refresh undotree highlights if window is open
        if vim.fn.exists('t:undotree') == 1 then
          vim.cmd('UndotreeHide | UndotreeShow')
        end
      end,
    })
    
    -- Better undo persistence
    vim.opt.undofile = true
    vim.opt.undolevels = 10000
    vim.opt.undoreload = 10000
  end,
}