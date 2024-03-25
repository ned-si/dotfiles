-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- [[ Basic Keymaps ]]
vim.keymap.set(
  "n",
  "<leader>pv",
  vim.cmd.Ex,
  { desc = "Open current file directory" }
)

-- Invert `:` and `;` in normal and visual modes
-- vim.keymap.set({ "n", "v" }, ";", ":")
-- vim.keymap.set({ "n", "v" }, ":", ";")
-- no need anymore, done at the keyboard level

-- Remap for dealing with word wrap
vim.keymap.set(
  "n",
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)
vim.keymap.set(
  "n",
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)

-- Allow `'` to act like `\`` in normal mode
vim.keymap.set("n", "'", "`")

-- Terminal stuff
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l")
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")

-- Old habits
vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape" })

-- There are other worlds
vim.keymap.set(
  { "n", "v" },
  "<leader>y",
  '"+y',
  { desc = "[Y]ank to other worlds" }
)
vim.keymap.set(
  "n",
  "<leader>Y",
  'gg"+yG',
  { desc = "[Y]ank buffer to other worlds" }
)
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "[P]aste to the void" })
vim.keymap.set("n", "<leader>d", '"_d', { desc = "[D]elete to the void" })

-- Move lines in visual mode
vim.keymap.set(
  "v",
  "J",
  ":m '>+1<CR>gv=gv",
  { desc = "Move line down visually" }
)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up visually" })

-- `J` without moving cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Keep things centered while moving
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Avoid `Q`
vim.keymap.set("n", "Q", "<nop>")

-- Tmux-Sessionizer
vim.keymap.set(
  "n",
  "<leader>ts",
  "<cmd>silent !tmux neww tmux-sessionizer<CR>",
  { desc = "[T]mux-[S]essionizer" }
)

-- Choose YAML schema FIXME: not working
-- vim.keymap.set(
--   "n",
--   "<leader>sy",
--   "<cmd>Telescope yaml_schema<CR>",
--   { desc = "Telescope - [S]earch [Y]AML schema" }
-- )

-- toggle conceallevel
vim.keymap.set(
  "n",
  "<leader>tc",
  "<cmd>setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>",
  { desc = "[T]oggle [C]onceallevel" }
)

-- lazy
vim.keymap.set("n", "<leader>a", "<cmd>Lazy<cr>", { desc = "L[a]zy" })

-- Diff current windows
vim.keymap.set(
  "n",
  "<leader>dt",
  "<cmd>windo diffthis<CR>",
  { desc = "[D]iff[T]his" }
)
vim.keymap.set("n", "<leader>du", "<cmd>diffoff<CR>", { desc = "[D]iff[O]ff" })

-- Make current file executable
vim.keymap.set(
  "n",
  "<leader>x",
  "<cmd>!chmod +x %<CR>",
  { silent = true, desc = "Make current file e[X]ecutable" }
)
