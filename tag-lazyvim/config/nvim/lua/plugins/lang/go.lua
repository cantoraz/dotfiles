return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      -- required by extra `lang.go`, but provided by system rather than Mason
      local preinstalled = {
        "goimports", -- Go Package
        -- "gofumpt",
        "gomodifytags", -- Go Package
        -- "impl",
        "golangci-lint",
        "delve", -- Go Package
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
        -- required by extra `lang.go`, but provided by system rather than Mason
        gopls = { mason = false },
      },
    },
  },
}
