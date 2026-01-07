return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = { mason = false },
      cssls = { mason = false },
      html = { mason = false },
      jsonls = { mason = false, },
    },
  },
}
