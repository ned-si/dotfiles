require("toggleterm").setup({
  direction = 'horizontal',
  open_mapping = [[<C-t>]],
})

vim.keymap.set("n", "<leader>ta", ":ToggleTermToggleAll<CR>", { desc = "[T]oggleTerm [A]all" })
vim.keymap.set({"n", "v"}, "<leader>tv", ":ToggleTermSendVisualSelection<CR>", { desc = "[T]oggleTerm send [V]isual selection" })
