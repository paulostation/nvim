-- ~/.config/nvim/lua/plugins/formatting.lua
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        helm = {}, -- no formatter
        python = { "ruff_fix", "ruff_format" },
        lua = { "stylua" },
        sh = { "shfmt" },
      },
      notify_on_error = true, -- optional but handy
    },
  },
}
