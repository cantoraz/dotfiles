return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local preinstalled = { "stylua", "shfmt", "shellcheck" }
      local function missing(package)
        return not vim.tbl_contains(preinstalled, package)
      end
      opts.ensure_installed = vim.tbl_filter(missing, opts.ensure_installed)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- required by extra `util.dot`, but provided by system rather than Mason
        bashls = { mason = false },
      },
    },
  },
}
