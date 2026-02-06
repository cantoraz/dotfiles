return {
  -- set the border of the float window
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          border = "rounded",
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
      signature = {
        window = {
          border = "rounded",
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
    },
  },

  -- enable chunked indent
  {
    "snacks.nvim",
    opts = {
      indent = {
        chunk = {
          enabled = true,
        },
      },
    },
  },

  -- customize dashboard
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
      },
    },
  },

  -- cutomize statusline and winbar
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- options

      local winbar_disabled_filetypes = {
        "checkhealth",
        "gitsigns-blame",
        "grug-far",
        "help",
        "noice",
        "qf",
        "snacks_layout_box",
        "snacks_terminal",
        "trouble",
      }
      opts.options.disabled_filetypes.winbar =
        vim.list_extend(winbar_disabled_filetypes, opts.options.disabled_filetypes.statusline)

      -- statusline

      local len_sl_c = #opts.sections.lualine_c
      local pretty_path = opts.sections.lualine_c[len_sl_c - 1]
      local trouble_symbols = opts.sections.lualine_c[len_sl_c]

      opts.sections.lualine_y = { "filetype", "filesize", "encoding", "fileformat", "progress" }
      opts.sections.lualine_z = { "location" }

      -- winbar

      -- stylua: ignore
      local function window_num() return vim.api.nvim_win_get_number(0) end
      -- stylua: ignore
      local blank = { function() return " " end, separator = "" }

      opts.winbar = {
        lualine_a = { { window_num, color = "lualine_a_normal" } },
        lualine_c = { pretty_path, trouble_symbols },
        lualine_x = { blank, { "lsp_status", separator = " " } },
      }

      opts.inactive_winbar = {
        lualine_a = { { window_num, color = "lualine_b_normal" } },
        lualine_c = { pretty_path },
        lualine_x = { blank },
      }
    end,
  },
}
