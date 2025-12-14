-- lua/plugins/opencode.lua
return {
  "sudo-tee/opencode.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        file_types = { "markdown", "opencode_output" },
      },
      ft = { "markdown", "opencode_output" },
    },
    "folke/snacks.nvim", -- for picker UI
  },
  config = function()
    require("opencode").setup({
      default_global_keymaps = false,
      keymap = {
        editor = {
          ["<leader>aa"] = { "toggle", desc = "OpenCode: Toggle UI" },
          ["<leader>ac"] = { "open_input_new_session", desc = "OpenCode: New Session" },
        },
      },
      context = {
        enabled = true,
        current_file = { enabled = true },
        selection = { enabled = true },
        diagnostics = { warn = true, error = true },
      },
    })
  end,
}
