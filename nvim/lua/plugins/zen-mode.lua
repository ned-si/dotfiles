return {
  {
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        gitsigns = { enabled = true },
        tmux = { enabled = true },
        diagnostics = { enabled = true },
      },
    },
    keys = {
      {
        "<leader>zm",
        "<cmd>ZenMode<cr>",
        desc = "[Z]en [M]ode",
      },
    },
  },
  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.4,
        inactive = true,
      },
    },
    keys = {
      {
        "<leader>tt",
        "<cmd>Twilight<cr>",
        desc = "[T]oggle [T]wilight",
      },
    },
  },
}
