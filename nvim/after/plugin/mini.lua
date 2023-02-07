require('mini.trailspace').setup()
require('mini.align').setup()

-- Trim white spaces
vim.keymap.set("n", "<leader>tw", ":lua MiniTrailspace.trim()<CR>", {desc = "[T]rim [W]hite spaces"})
vim.keymap.set("n", "<leader>tl", ":lua MiniTrailspace.trim_last_lines()<CR>", {desc = "[T]rim [L]ast lines"})
