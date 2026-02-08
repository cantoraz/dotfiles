return {
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        -- required by extra `lang.python`, but provided by system rather than Mason
        [vim.g.lazyvim_python_lsp or "pyright"] = { mason = false },
        [vim.g.lazyvim_python_ruff or "ruff"] = { mason = false },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        python = { "ruff" },
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      automatic_installation = { exclude = { "python" } },
    },
  },
}
