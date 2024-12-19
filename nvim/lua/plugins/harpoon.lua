return {
  "ThePrimeagen/harpoon",
  lazy = false,
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = true,
  keys = {
    {
      "<leader>ha",
      "<cmd>lua require('harpoon.mark').add_file()<cr>",
      desc = "[H]aqroon - [A]dd file",
    },
    {
      "<leader>hn",
      "<cmd>lua require('harpoon.ui').nav_next()<cr>",
      desc = "[H]arpoon - [N]ext file",
    },
    {
      "<leader>hp",
      "<cmd>lua require('harpoon.ui').nav_prev()<cr>",
      desc = "[H]arpoon - [P]revious file",
    },
    {
      "<leader>hg",
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
      desc = "[H]arpoon [G]",
    },
    {
      "<leader>j",
      "<cmd>lua require('harpoon.ui').nav_file(1)<cr>",
      desc = "[H]arpoon - File [1]",
    },
    {
      "<leader>k",
      "<cmd>lua require('harpoon.ui').nav_file(2)<cr>",
      desc = "[H]arpoon - File [2]",
    },
    {
      "<leader>l",
      "<cmd>lua require('harpoon.ui').nav_file(3)<cr>",
      desc = "[H]arpoon - File [3]",
    },
    {
      "<leader>:",
      "<cmd>lua require('harpoon.ui').nav_file(4)<cr>",
      desc = "[H]arpoon - File [4]",
    },
  },
}
