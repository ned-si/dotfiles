return {
  {
    "echasnovski/mini.files",
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        replace = "cs",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "echasnovski/mini.align",
    version = false,
  },
  {
    "echasnovski/mini.trailspace",
    version = false,
    config = function()
      require("mini.trailspace").setup()
    end,
    keys = {
      {
        "<leader>tw",
        "<cmd>lua MiniTrailspace.trim()<cr>",
        desc = "[T]rim [W]hitespaces",
      },
      {
        "<leader>tl",
        "<cmd>lua MiniTrailspace.trim_last_lines()<cr>",
        desc = "[T]rim [L]ast lines",
      },
    },
  },
}
