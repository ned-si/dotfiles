require("ts-node-action").setup({})

vim.keymap.set({ "n" }, "<leader>na", require("ts-node-action").node_action, { desc = "Trigger [N]ode [A]ction" })
