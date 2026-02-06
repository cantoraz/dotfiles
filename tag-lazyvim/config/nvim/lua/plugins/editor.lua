return {
  -- converting text case
  {
    "johmsalas/text-case.nvim",
    config = true,
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
      "Subs",
      "TextCaseStartReplacingCommand",
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    lazy = false,
  },

  -- open Yazi file manager in a floating window
  {
    "mikavilpas/yazi.nvim",
    version = "*", -- use the latest stable version
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      { "<leader>fy", "<cmd>Yazi<cr>", mode = { "n", "v" }, desc = "Yazi (Directory of Current File)" },
      { "<leader>fY", "<cmd>Yazi cwd<cr>", desc = "Yazi (cwd)" },
      { "<leader>f<tab>", "<cmd>Yazi toggle<cr>", desc = "Yazi (Last Session)" },
    },
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      -- open_for_directories = true,
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    -- init = function()
    --   -- mark netrw as loaded so it's not loaded at all.
    --   --
    --   -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    --   vim.g.loaded_netrwPlugin = 1
    -- end,
  },
  -- Don't bring Snacks Explorer up when opening a directory
  -- {
  --   "snacks.nvim",
  --   optional = true,
  --   opts = {
  --     explorer = {
  --       replace_netrw = false,
  --     },
  --   },
  -- },
}
