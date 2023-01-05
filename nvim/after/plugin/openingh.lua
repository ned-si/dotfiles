-- Open Github
-- for repository page
vim.api.nvim_set_keymap("n", "<Leader>gr", ":OpenInGHRepo <CR>", { desc = 'Open [G]ithub [R]epo', expr = true, noremap = true })

-- for current file page
vim.api.nvim_set_keymap("n", "<Leader>gf", ":OpenInGHFile <CR>", { desc = 'Open [G]ithub [F]ile', expr = true, noremap = true })
