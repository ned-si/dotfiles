-- Loaded before lazy.nvim starts. LazyVim's own defaults are applied first:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Must be set here, before the lang.python extra is evaluated. That extra
-- defaults to pyright and then explicitly sets enabled = false on every other
-- python server, so configuring basedpyright without flipping this leaves you
-- with ruff and nothing else attached.
vim.g.lazyvim_python_lsp = "basedpyright"

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.local/nvim/undodir"

opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 5
opt.updatetime = 50
opt.colorcolumn = "80"
opt.textwidth = 80
opt.breakindent = true
opt.wrap = true
opt.mouse = "a"

-- Markdown and LaTeX are more readable with concealed syntax; <leader>tc
-- toggles it when the raw text is what you actually need.
opt.conceallevel = 2

opt.isfname:append("@-@")

-- Overriding LazyVim, deliberately ------------------------------------------

-- Yanks stay in nvim's registers. Crossing into the system clipboard is always
-- explicit, via <leader>y and friends.
opt.clipboard = ""

-- No writing on buffer switch, and no format-on-save. Formatting is a
-- deliberate act here (<leader>cf), because reformatting a file you only opened
-- to read produces noisy diffs.
opt.autowrite = false
vim.g.autoformat = false

opt.cursorline = false
opt.list = false
opt.laststatus = 2

-- LazyVim turns this on, which makes :q on a modified buffer pop a
-- "Save changes to ...?" dialog instead of failing with E37. That is not vim
-- behaviour and it reads as ":q stopped working". Back to the standard: :q
-- refuses, :q! discards, :wq writes.
opt.confirm = false

-- Spell checking is handled per-filetype by ltex-ls-plus for prose, rather than
-- vim's dictionary flagging every identifier in source files.
opt.spell = false
opt.spelllang = ""

-- Keep gq on vim's own paragraph formatter instead of handing it to the LSP,
-- which reflows far more than the selection in most servers.
opt.formatexpr = ""
