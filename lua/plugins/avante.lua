return {
  "yetone/avante.nvim",
  enabled = false,
  build = "bash build.sh",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- Load native libs first (safe if already loaded)
    pcall(function()
      local lib = require("avante_lib")
      if lib and lib.load then
        lib.load()
      end
    end)

    require("avante").setup({
      provider = "ollama",
      providers = {
        ollama = {
          endpoint = "http://localhost:11434",
          model = "deepseek-r1:7b",
          temperature = 0.0,
        },
      },
    })
  end,
}
