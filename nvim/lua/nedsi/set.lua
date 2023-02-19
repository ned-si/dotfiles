-- [[ Setting options ]]
-- See `:help vim.o`

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.conceallevel = 2

-- NOTE: not sure this is actually doing anything
vim.g.markdown_fenced_languages = {
  "json",
  "vim",
  "lua",
  "go",
  "bash",
  "hcl",
  "yaml"
}


-- Enable mouse mode
vim.opt.mouse = "a"

-- Enable break indent
vim.opt.breakindent = true

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- nerdtree
vim.g.NERDTreeShowLineNumbers=1
