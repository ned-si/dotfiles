return {
  "glepnir/template.nvim",
  cmd = { "Template", "TemProject" },
  config = function()
    require("template").setup({
      temp_dir = "~/.config/nvim/templates",
      author = "nedsi",
      email = "nedsi@pm.me",
    })
  end,
  keys = {
    {
      "<leader>ft",
      "<cmd>Telescope find_template<cr>",
      desc = "[F]ind [T]emplate",
    },
    -- FIXME: not working
    -- {
    --   "<leader>ft",
    --   function()
    --     require("telescope").extensions.find_template.templates()
    --   end,
    --   desc = "[F]ind [T]emplate",
    -- },
    {
      "<leader>ti",
      function()
        require("telescope").extensions.find_template.insert()
      end,
      desc = "[T]emplate [I]nsert",
    },
  },
}
