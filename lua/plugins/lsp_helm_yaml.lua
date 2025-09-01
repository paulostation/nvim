return {
  "neovim/nvim-lspconfig",
  ---@type lspconfig.options
  opts = {
    servers = {
      -- HELM: attach only to filetype=helm
      helm_ls = {
        filetypes = { "helm" },
      },

      -- YAML: explicitly exclude helm
      yamlls = {
        filetypes = { "yaml", "yml", "yaml.docker-compose" }, -- no "helm" here
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            format = { enable = true },
            validate = true,
            schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
            schemas = {
              kubernetes = { "k8s/**/*.yaml", "manifests/**/*.yaml" },
            },
          },
        },
      },
    },

    -- global on_attach guard: if yamlls ever lands on a helm buffer, stop it
    setup = {
      yamlls = function(_, _)
        local lspconfig = require("lspconfig")
        local orig = lspconfig.util.default_config.on_attach
        lspconfig.util.default_config.on_attach = function(client, bufnr)
          if orig then
            orig(client, bufnr)
          end
          if client.name == "yamlls" and vim.bo[bufnr].filetype == "helm" then
            client.stop()
          end
        end
        -- let LazyVim continue with default setup
        return false
      end,
      helm_ls = function()
        return false
      end,
    },
  },
}
