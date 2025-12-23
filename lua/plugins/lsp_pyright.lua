-- Disable pyright in favor of ty for Python type checking
-- To re-enable: delete this file
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          enabled = false,
        },
      },
    },
  },
}
