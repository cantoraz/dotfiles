return {
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        -- required by extra `lang.json`, but provided by system rather than Mason
        jsonls = { mason = false },
      },
    },
  },
}
