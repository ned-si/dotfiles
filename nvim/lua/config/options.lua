-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.nu = true
opt.relativenumber = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.smartindent = true

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.local/nvim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 5
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50

opt.colorcolumn = "80"

opt.conceallevel = 2

-- NOTE: not sure this is actually doing anything
vim.g.markdown_fenced_languages = {
  "json",
  "vim",
  "lua",
  "go",
  "bash",
  "yaml",
}

-- Enable mouse mode
opt.mouse = "a"

-- Enable break indent
opt.breakindent = true

-- Set completeopt to have a better completion experience
opt.completeopt = "menuone,noselect,preview"

-- Case insensitive searching UNLESS /C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- nerdtree
vim.g.NERDTreeShowLineNumbers = 1

-- Fixing Lazyvim
opt.autowrite = false
opt.cursorline = false
opt.clipboard = ""
opt.wrap = true
opt.list = false
opt.spell = false
opt.spelllang = ""

vim.g.autoformat = false
vim.b.autoformat = false
