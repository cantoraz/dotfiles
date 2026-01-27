return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local preinstalled = { "stylua", "shfmt" }
      local function missing(package)
        return not vim.tbl_contains(preinstalled, package)
      end
      opts.ensure_installed = vim.tbl_filter(missing, opts.ensure_installed)
    end,
  },
}
