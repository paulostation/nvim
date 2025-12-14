-- Force OpenCode to run in server mode (avoids /dev/tty errors)
vim.env.OPENCODE_CONFIG = vim.fn.expand("~/.config/opencode/config.json")
vim.env.OPENCODE_MODE = "server"
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.bigfile")
