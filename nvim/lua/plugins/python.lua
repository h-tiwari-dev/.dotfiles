return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          mason = false, -- Stop automatic installation via Mason
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
              },
            },
          },
        },
      },
    },
  },
}
