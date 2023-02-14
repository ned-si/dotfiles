require("toggleterm").setup({
  direction = 'vertical',
  open_mapping = [[<C-t>]],
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return 111
    end
  end,
})

vim.keymap.set("n", "<leader>ta", ":ToggleTermToggleAll<CR>", { desc = "[T]oggleTerm [A]all" })
vim.keymap.set({ "n", "v" }, "<leader>tv", ":ToggleTermSendVisualSelection<CR>",
  { desc = "[T]oggleTerm send [V]isual selection" })
