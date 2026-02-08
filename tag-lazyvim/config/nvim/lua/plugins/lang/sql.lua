return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      -- required by extra `lang.sql`, but provided by system rather than Mason
      local preinstalled = { "sqlfluff" }
      opts.ensure_installed = vim.tbl_filter(function(package)
        return not vim.tbl_contains(preinstalled, package)
      end, opts.ensure_installed)
    end,
  },
}
