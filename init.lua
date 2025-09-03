-- Load core configuration modules
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup {

  -- Core plugin modules
  require 'plugins.utils',
  require 'plugins.which-key',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.formatting',
  require 'plugins.completion',
  require 'plugins.colorscheme',
  require 'plugins.ui',
  require 'plugins.treesitter',
  require 'plugins.icons',
  require 'plugins.diagnostics',

  require 'plugins.debug',
  require 'plugins.lint',
  require 'plugins.autopairs', -- enhanced with blink.cmp integration
  require 'plugins.oil',
  require 'plugins.gitsigns', -- adds gitsigns recommend keymaps
  require 'plugins.neogit', -- modern git interface
  require 'plugins.flash', -- fast navigation with search labels
  require 'plugins.noice', -- enhanced UI for messages/cmdline/popupmenu
  require 'plugins.neoscroll', -- smooth scrolling animations
  require 'plugins.undotree', -- visual undo history with TokyoNight theming
  require 'plugins.toggleterm', -- advanced terminal management with floating/split terminals
  require 'plugins.bufferline', -- modern buffer tabs with diagnostics and TokyoNight theming
  require 'plugins.rustaceanvim', -- comprehensive Rust IDE features with rust-analyzer integration
}
