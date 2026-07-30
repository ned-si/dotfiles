return {
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    opts = {},
    keys = {
      {
        "<leader>na",
        function()
          require("ts-node-action").node_action()
        end,
        desc = "[N]ode [A]ction",
      },
    },
  },
}
