return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      local preinstalled = {
        -- required by extra `util.dot`, but provided by system rather than Mason
        "shellcheck",
        -- required by LazyVim default, but provided by system rather than Mason
        "shfmt",
      }
      opts.ensure_installed = vim.tbl_filter(function(package)
        return not vim.tbl_contains(preinstalled, package)
      end, opts.ensure_installed)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        -- required by extra `util.dot`, but provided by system rather than Mason
        bashls = { mason = false },
      },
    },
  },
}
