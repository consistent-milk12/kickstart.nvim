-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Force help windows to open vertically
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = { '*.txt', '*.help' },
  callback = function()
    if vim.bo.buftype == 'help' then
      vim.cmd('wincmd L') -- Move help to vertical split on the right
    end
  end,
})

-- Force quickfix/loclist to open horizontally at bottom
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qf' },
  callback = function()
    vim.cmd('wincmd J') -- Move quickfix to bottom
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})