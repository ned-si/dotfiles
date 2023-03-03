vim.g.papyrus_latex_engine = 'xelatex'
vim.g.papyrus_viewer = 'okular'
vim.g.papyrus_template = 'default'

vim.keymap.set("n", "<leader>pac", ":PapyrusCompile<CR>", { desc = "[PA]pyrus [C]ompile" })
vim.keymap.set("n", "<leader>paa", ":PapyrusAutoCompile<CR>", { desc = "[PA]pyrus [A]utocompile" })
vim.keymap.set("n", "<leader>pav", ":PapyrusView<CR>", { desc = "[PA]pyrus [V]iew" })
vim.keymap.set("n", "<leader>pas", ":PapyrusStart<CR>", { desc = "[PA]pyrus [S]tart" })
