require("sessions").setup({
    -- session_filepath = ".session",
    session_filepath = vim.fn.stdpath("data") .. "/sessions",
    absolute = true,
})

vim.keymap.set("n", "<leader>es", vim.cmd.SessionsSave, { desc = "S[E]ssion [S]ave" })
vim.keymap.set("n", "<leader>et", vim.cmd.SessionsStop, { desc = "S[E]ssion s[T]op" })
vim.keymap.set("n", "<leader>el", vim.cmd.SessionsLoad, { desc = "S[E]ssion [L]oad" })
