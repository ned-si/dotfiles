-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.local/nvim/undodir"

opt.scrolloff = 5
opt.updatetime = 50
opt.colorcolumn = "80"
opt.textwidth = 80
opt.spell = false
opt.spelllang = ""
opt.laststatus = 2

vim.g.autoformat = false
vim.b.autoformat = false

-- Fixing Lazyvim
opt.autowrite = false
opt.clipboard = ""
