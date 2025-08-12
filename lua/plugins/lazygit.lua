return {
  "kdheepak/lazygit.nvim",
  cmd = { "LazyGit", "LazyGitCurrentFile" },
  keys = {
    -- open lazygit in cwd:
    { "<leader>gG", "<cmd>LazyGit<cr>", desc = "LazyGit (cwd)" },

    -- always open in the repo root of your current file or the selected node in Nvim-Tree:
    {
      "<leader>gg",
      function()
        local api = require("nvim-tree.api")
        local target_dir

        if vim.bo.filetype == "NvimTree" then
          -- use the node (file or folder) under the cursor in Nvim-Tree
          local node = api.tree.get_node_under_cursor()
          if not node or not node.absolute_path then
            vim.notify("No node under cursor in Nvim-Tree!", vim.log.levels.WARN)
            return
          end
          if vim.fn.isdirectory(node.absolute_path) == 1 then
            target_dir = node.absolute_path
          else
            target_dir = vim.fn.fnamemodify(node.absolute_path, ":h")
          end
        else
          -- fallback to the directory of the active buffer
          target_dir = vim.fn.expand("%:p:h")
        end

        -- find the Git repo root
        local cmd = "git -C " .. vim.fn.shellescape(target_dir) .. " rev-parse --show-toplevel"
        local git_root = vim.fn.systemlist(cmd)[1]
        if vim.v.shell_error ~= 0 or git_root == "" then
          vim.notify("Not inside a Git repo: " .. target_dir, vim.log.levels.WARN)
          return
        end

        -- change Neovim’s global cwd so explorers & pickers follow
        vim.api.nvim_set_current_dir(git_root)

        -- refresh Nvim-Tree root (if in use)
        pcall(function()
          api.tree.change_root(git_root)
        end)

        -- launch LazyGit
        vim.cmd("LazyGit")
      end,
      desc = "LazyGit (repo root or Nvim-Tree node)",
    },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    vim.g.lazygit_floating_window_winblend = 0
    vim.g.lazygit_floating_window_scaling_factor = 0.9
    vim.g.lazygit_floating_window_border_chars = { "╭", "╮", "╰", "╯", "│", "─", "│", "─" }
    vim.g.lazygit_use_neovim_remote = 1
  end,
}
