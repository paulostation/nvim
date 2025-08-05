return {
  "LunarVim/bigfile.nvim",
  event = "BufReadPre",
  opts = {
    filesize = 2, -- MB
    pattern = "*",
    features = {
      "indent_blankline",
      "illuminate",
      "lsp",
      "treesitter",
      "syntax",
      "matchparen",
    },
  },
}

