return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")

      -- Define ty LSP if not already defined
      if not configs.ty then
        configs.ty = {
          default_config = {
            cmd = { "ty", "server" },
            filetypes = { "python" },
            root_dir = lspconfig.util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", ".git"),
            single_file_support = true,
            settings = {},
          },
        }
      end

      -- Add ty to servers
      opts.servers = opts.servers or {}
      opts.servers.ty = {}
    end,
  },
}
