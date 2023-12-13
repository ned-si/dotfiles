return {
  {
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        gitsigns = { enabled = true },
        tmux = { enabled = true },
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
      keys = {
        "<leader>tt",
        function()
          require("twilight").toggle()
        end,
        desc = "[T]oggle [T]wilight",
      },
    },
  },
}
