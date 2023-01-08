-- Enable ChatGPT.nvim
require('chatgpt').setup({})

vim.keymap.set("n", "<leader>cg", vim.cmd.ChatGPT,{ desc = "[C]hat[G]PT" })
vim.keymap.set("n", "<leader>ce", vim.cmd.ChatGPTEditWithInstructions,{ desc = "[C]hatGPT [E]dit with instructions" })
