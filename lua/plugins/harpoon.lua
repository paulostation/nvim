return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2", -- latest version (requires >= Neovim 0.9)
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()
  end,
  keys = {
    { "<leader>m", function() require("harpoon"):list():append() end, desc = "Mark file with Harpoon" },
    { "<leader>h", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Quick Menu" },
    { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon: Go to file 1" },
    { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon: Go to file 2" },
    { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon: Go to file 3" },
    { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon: Go to file 4" },
  },
}

