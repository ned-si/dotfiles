-- Default settings
require("swap-split").setup({
    ignore_filetypes = {
        "NvimTree"
    }
})

local map = vim.api.nvim_set_keymap
map('n', '<leader>S', '<cmd>lua require("swap-split").swap()<CR>', { noremap = true })
