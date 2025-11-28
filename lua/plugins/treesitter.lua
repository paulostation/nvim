-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Make sure we always ignore the jsonc parser installation
      local ignore = opts.ignore_install or {}
      table.insert(ignore, "jsonc")
      opts.ignore_install = ignore
      return opts
    end,
  },
}
