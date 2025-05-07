return {
  {
    "xorid/swap-split.nvim",
    keys = {
      {
        "<leader>ss",
        function()
          require("swap-split").swap()
        end,
        desc = "[S]wap [S]plit",
      },
    },
  },
}
