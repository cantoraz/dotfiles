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
        -- required by extra `lang.python`, but provided by system rather than Mason
        [vim.g.lazyvim_python_lsp or "pyright"] = { mason = false },
        [vim.g.lazyvim_python_ruff or "ruff"] = { mason = false },
      },
    },
  },
}
