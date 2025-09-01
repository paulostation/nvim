return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Some setups register as `ruff_lsp`, others as `ruff`.
        ruff_lsp = {
          on_attach = function(client, _)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
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
