return {
  {
    "editorconfig/editorconfig-vim",
    -- Option A: load on open and on new files
    event = { "BufReadPre", "BufNewFile" },

    -- Option B (stronger): load eagerly so it’s always on
    -- lazy = false,
    -- priority = 1000,
  },
}
