-- LazyVim's defaults are set first and are not repeated here:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Old habits ---------------------------------------------------------------
map("i", "jj", "<Esc>", { desc = "Escape" })

-- ' is easier to reach than ` for jumping to an exact mark.
map("n", "'", "`")

map("n", "Q", "<nop>")

-- Move by display line when wrapped, unless a count was given.
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clipboard ----------------------------------------------------------------
-- opt.clipboard is empty on purpose, so crossing into the system clipboard is
-- always an explicit act.
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", 'gg"+yG', { desc = "Yank buffer to system clipboard" })
map("x", "<leader>p", '"_dP', { desc = "Paste over selection, keep register" })
map("n", "<leader>d", '"_d', { desc = "Delete without clobbering register" })

-- Yank the current file's path in various shapes. macOS only; the Linux branch
-- of this used the + register, but * and + are the same thing here.
map("n", "<leader>yr", ':let @+=expand("%")<CR>', { silent = true, desc = "Yank relative path" })
map("n", "<leader>yp", ':let @+=expand("%:p")<CR>', { silent = true, desc = "Yank absolute path" })
map("n", "<leader>yf", ':let @+=expand("%:t")<CR>', { silent = true, desc = "Yank filename" })
map("n", "<leader>yd", ':let @+=expand("%:p:h")<CR>', { silent = true, desc = "Yank directory" })

-- Motion -------------------------------------------------------------------
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Join without letting the cursor drift to the join point.
map("n", "J", "mzJ`z")

-- Keep the cursor centred while scrolling and searching.
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Terminal -----------------------------------------------------------------
map("t", "<C-h>", "<C-\\><C-N><C-w>h")
map("t", "<C-j>", "<C-\\><C-N><C-w>j")
map("t", "<C-k>", "<C-\\><C-N><C-w>k")
map("t", "<C-l>", "<C-\\><C-N><C-w>l")
map("t", "<Esc>", "<C-\\><C-N>")

-- Tools --------------------------------------------------------------------
map("n", "<leader>ts", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Tmux sessionizer" })
map("n", "<leader>a", "<cmd>Lazy<cr>", { desc = "Lazy" })

map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

map("n", "<leader>dt", "<cmd>windo diffthis<CR>", { desc = "Diff open windows" })
map("n", "<leader>du", "<cmd>diffoff!<CR>", { desc = "Diff off" })

-- conceallevel hides markdown and LaTeX markup; toggle it to edit the raw text.
map("n", "<leader>tc", function()
  vim.opt_local.conceallevel = vim.opt_local.conceallevel:get() == 0 and 2 or 0
end, { desc = "Toggle conceallevel" })
