return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
  },
  opts = {
    -- If you have a local Claude installation, uncomment and configure:
    -- terminal_cmd = "~/.claude/local/claude", -- Point to local installation
    -- Auto-start Claude Code when opening Neovim
    auto_start = false,
    -- Window configuration
    window = {
      width = "50%", -- Width of Claude Code window
      height = "100%", -- Height of Claude Code window
      position = "right", -- Position: "right", "left", "bottom", "top", "float"
    },
  },
}