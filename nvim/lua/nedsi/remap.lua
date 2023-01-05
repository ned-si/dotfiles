-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Invert `:` and `;` in normal and visual modes
vim.keymap.set('n', ';', ":")
vim.keymap.set('n', ':', ";")
vim.keymap.set('v', ';', ":")
vim.keymap.set('v', ':', ";")

-- Allow `'` to act like `\`` in normal mode
vim.keymap.set('n', "'", "`")

-- Easy moves between windows
vim.keymap.set('n', '<C-h>', "<C-w>h")
vim.keymap.set('n', '<C-j>', "<C-w>j")
vim.keymap.set('n', '<C-k>', "<C-w>k")
vim.keymap.set('n', '<C-l>', "<C-w>l")

-- Easy moves when using terms
vim.keymap.set('t', '<C-h>', "<C-\\><C-N><C-w>h")
vim.keymap.set('t', '<C-j>', "<C-\\><C-N><C-w>j")
vim.keymap.set('t', '<C-k>', "<C-\\><C-N><C-w>k")
vim.keymap.set('t', '<C-l>', "<C-\\><C-N><C-w>l")

-- Easy resize windows
vim.keymap.set('n', '<C-left>', ':vertical resize -5<CR>')
vim.keymap.set('n', '<C-down>', ':resize +5<CR>')
vim.keymap.set('n', '<C-up>', ':resize -5<CR>')
vim.keymap.set('n', '<C-right>', ':vertical resize +5<C')

-- Old habits
vim.keymap.set('i', 'jj', '<Esc>')

-- There are other worlds
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', 'gg"+yG')
vim.keymap.set('x', '<leader>p', '"_dP')
vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')

-- Move lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- `J` without moving cursor
vim.keymap.set('n', 'J', 'mzJ`z')

-- Keep things centered while moving
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Avoid `Q`
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', 'C-f', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

-- Search and replace word current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Show keymaps
vim.keymap.set("n", "<leader>tk", ":Telescope keymaps<CR>")

-- Choose YAML schema
vim.keymap.set("n", "<leader>fy", ":Telescope yaml_schema<CR>")

-- Might be useful at some point, keep in mind
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
