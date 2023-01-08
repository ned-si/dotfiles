require("sessions").setup({
    session_filepath = ".session",
})

vim.keymap.set("n", "<leader>es", vim.cmd.SessionsSave, { desc = "S[E]ssion [S]ave" })
vim.keymap.set("n", "<leader>el", vim.cmd.SessionsLoad, { desc = "S[E]ssion [L]oad" })
