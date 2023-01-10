local saga = require('lspsaga')

saga.init_lsp_saga({
  definition_action_keys = {
    edit = '<C-c>o', -- [o]pen
    vsplit = '<C-c>v',
    split = '<C-c>s',
    tabe = '<C-c>t',
    quit = 'q',
  },
})

-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump backlspsaga
vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { desc = 'LSP: [G]et [H]elp', silent = true })

-- Code action
vim.keymap.set({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = 'LSP: [C]ode [A]ction', silent = true })

-- Rename - replaced by inc-rename
-- vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { desc = 'LSP: [G]oto [D]efinition', silent = true })

-- Show cursor diagnostics
vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { desc = 'LSP: show [C]urrent [D]iagnostic', silent = true })

-- Diagnostic jump can use `<c-o>` to jump back
vim.keymap.set("n", "<C-p>", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "LSP: Diagnostic [P]revious", silent = true })
vim.keymap.set("n", "<C-n>", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "LSP: Diagnostic [N]ext", silent = true })

-- Only jump to error
vim.keymap.set("n", "[E", function()
  require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
vim.keymap.set("n", "]E", function()
  require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

-- Outline
vim.keymap.set("n","<leader>o", "<cmd>Lspsaga outline<CR>",{ desc = "LSP: Show [O]utline", silent = true })

-- Hover Doc
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = 'Hover Documentation', silent = true })
