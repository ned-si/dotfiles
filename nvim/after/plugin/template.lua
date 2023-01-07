require('template').setup({
  temp_dir = '~/.config/nvim/templates',
  author = 'nedsi',
  email = 'nedsi@pm.me'
})

vim.keymap.set("n", "<leader>st", ":Telescope find_template<CR>", { desc = "Telescope - [S]earch [T]emplates" })
