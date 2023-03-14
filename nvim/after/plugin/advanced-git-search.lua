-- remaps
vim.api.nvim_create_user_command(
  "DiffCommitLine",
  "lua require('telescope').extensions.advanced_git_search.diff_commit_line()",
  { range = true }
)

vim.api.nvim_set_keymap(
  "v",
  "<leader>dcl",
  ":DiffCommitLine<CR>",
  { noremap = true, desc = "[D]iff [C]ommit [L]ine" }
)

vim.keymap.set("n", "<leader>dbf", ":Telescope advanced_git_search diff_branch_file<CR>",
  { desc = "[D]iff [B]ranch [F]ile" })
vim.keymap.set("n", "<leader>dcf", ":Telescope advanced_git_search diff_commit_file<CR>",
  { desc = "[D]iff [C]ommit [F]ile" })
vim.keymap.set("n", "<leader>scc", ":Telescope advanced_git_search search_log_content<CR>",
  { desc = "[S]earch [C]ommits [C]ontent" })
vim.keymap.set("n", "<leader>scf", ":Telescope advanced_git_search search_log_content_file<CR>",
  { desc = "[S]earch [C]ommits on [F]ile" })
vim.keymap.set("n", "<leader>sr", ":Telescope advanced_git_search checkout_reflog<CR>", { desc = "[S]earch [R]eflog" })
