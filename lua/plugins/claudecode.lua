-- lua/plugins/ai-claudecode.lua
-- Claude Code integration for Neovim using claudecode.nvim

return {
  "coder/claudecode.nvim",
  enabled = true,
  dependencies = {
    -- Optional but recommended for better terminal UX
    "folke/snacks.nvim",
  },

  -- Load on these commands
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeSend",
    "ClaudeCodeAdd",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },

  -- Core configuration. Defaults are sane; tweak if you want.
  opts = {
    -- Server behavior
    auto_start = true, -- start MCP server automatically
    log_level = "info", -- "trace", "debug", "info", "warn", "error"

    -- If you use Claude's local installer (`claude migrate-installer`),
    -- point directly to the local binary (otherwise leave as nil).
    -- terminal_cmd = vim.fn.expand("~/.claude/local/claude"),

    -- Focus the Claude terminal after successfully sending context
    focus_after_send = false,

    -- Track visual selections for better context
    track_selection = true,
    visual_demotion_delay_ms = 50,

    -- Terminal integration
    terminal = {
      -- Where to put the split when using the built-in terminal
      split_side = "right", -- "left" or "right"
      split_width_percentage = 0.30, -- 30% of the screen

      -- Provider can be "auto", "snacks", "native", "external", "none"
      provider = "auto",

      -- Auto-close terminal when Claude commands finish
      auto_close = true,

      -- Extra options passed to Snacks.terminal.open()
      snacks_win_opts = {},

      -- Provider-specific options
      provider_opts = {
        -- Example for external terminal (tmux, kitty, etc.) if you ever want:
        -- external_terminal_cmd = "alacritty -e %s",
      },
    },

    -- Diff view behavior when Claude proposes edits
    diff_opts = {
      auto_close_on_accept = true, -- close diff after accepting
      vertical_split = true,
      open_in_current_tab = true,
      keep_terminal_focus = false, -- true = focus back to Claude after opening diff
    },
  },

  -- Keymaps (mirroring the LazyVim ai.claudecode extra)
  -- Requires <leader> to be set; default in LazyVim is <Space>.
  keys = {
    { "<leader>a", nil, desc = "AI / Claude Code" },

    -- Main controls
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },

    -- Add context
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeSend<cr>",
      mode = "v",
      desc = "Send selection to Claude",
    },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file from file explorer",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },

    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
