-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Old habits
vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape" })

-- There are other worlds
vim.keymap.set(
  { "n", "v" },
  "<leader>y",
  '"+y',
  { desc = "[Y]ank to other worlds" }
)
vim.keymap.set(
  "n",
  "<leader>Y",
  'gg"+yG',
  { desc = "[Y]ank buffer to other worlds" }
)
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "[P]aste to the void" })
vim.keymap.set("n", "<leader>d", '"_d', { desc = "[D]elete to the void" })

-- `J` without moving cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Tmux-Sessionizer
vim.keymap.set(
  "n",
  "<leader>ts",
  "<cmd>silent !tmux neww tmux-sessionizer<CR>",
  { desc = "[T]mux-[S]essionizer" }
)
