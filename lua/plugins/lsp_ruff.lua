return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable old ruff_lsp (no longer exists, ruff uses `ruff server` now)
        ruff_lsp = {
          enabled = false,
        },
        ruff = {
          on_attach = function(client, _)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },
      },
    },
  },
}
