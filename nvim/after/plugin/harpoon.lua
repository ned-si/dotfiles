local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon - [A]dd file" })
vim.keymap.set("n", "<leader>ha", ui.toggle_quick_menu, { desc = "[HA]rpoon" })

vim.keymap.set("n", "<leader>j", function() ui.nav_file(1) end, { desc = "Harpoon - File 1" })
vim.keymap.set("n", "<leader>k", function() ui.nav_file(2) end, { desc = "Harpoon - File 2" })
vim.keymap.set("n", "<leader>l", function() ui.nav_file(3) end, { desc = "Harpoon - File 3" })
vim.keymap.set("n", "<leader>;", function() ui.nav_file(4) end, { desc = "Harpoon - File 4" })
