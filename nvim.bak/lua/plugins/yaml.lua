vim.keymap.set(
  "n",
  "<leader>ya",
  ":YAMLView<CR>",
  { desc = "[YA]ml View" }
)

vim.keymap.set(
  "n",
  "<leader>yay",
  ":YAMLYank<CR>",
  { desc = "[YA]ml [Y]ank all" }
)

vim.keymap.set(
  "n",
  "<leader>yak",
  ":YAMLYankKey<CR>",
  { desc = "[YA]ml [Y]ank [K]ey" }
)

vim.keymap.set(
  "n",
  "<leader>yav",
  ":YAMLYankValue<CR>",
  { desc = "[YA]ml [Y]ank [V]alue" }
)

vim.keymap.set(
  "n",
  "<leader>yaq",
  ":YAMLQuickfix<CR>",
  { desc = "[YA]ml [Q]uickfix" }
)

vim.keymap.set(
  "n",
  "<leader>yat",
  ":YAMLTelescope<CR>",
  { desc = "[YA]ml [T]Telescope" }
)

return {
  "cuducos/yaml.nvim",
  ft = { "yaml" }, -- optional
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
  },
}
