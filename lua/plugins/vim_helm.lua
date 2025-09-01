-- ~/.config/nvim/lua/plugins/vim_helm.lua
return {
  "towolf/vim-helm",
  lazy = false, -- load early so filetype=helm is set before LSP attaches
  priority = 1000,
}
