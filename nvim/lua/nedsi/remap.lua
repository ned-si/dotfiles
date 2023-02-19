-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open current file directory" })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Invert `:` and `;` in normal and visual modes
vim.keymap.set({'n', 'v'}, ';', ":")
vim.keymap.set({'n', 'v'}, ':', ";")

-- Allow `'` to act like `\`` in normal mode
vim.keymap.set('n', "'", "`")

-- Easy moves between windows
vim.keymap.set('n', '<C-h>', "<C-w>h", { desc = "Move to left Window" })
vim.keymap.set('n', '<C-j>', "<C-w>j", { desc = "Move to lower Window" })
vim.keymap.set('n', '<C-k>', "<C-w>k", { desc = "Move to upper Window" })
vim.keymap.set('n', '<C-l>', "<C-w>l", { desc = "Move to right Window" })

-- Terminal stuff
vim.keymap.set('t', '<C-h>', "<C-\\><C-N><C-w>h")
vim.keymap.set('t', '<C-j>', "<C-\\><C-N><C-w>j")
vim.keymap.set('t', '<C-k>', "<C-\\><C-N><C-w>k")
vim.keymap.set('t', '<C-l>', "<C-\\><C-N><C-w>l")
vim.keymap.set('t', '<Esc>', "<C-\\><C-N>")

-- Easy resize windows
vim.keymap.set('n', '<C-left>', ':vertical resize -5<CR>', { desc = "Resize smaller horizontally" })
vim.keymap.set('n', '<C-down>', ':resize +5<CR>', { desc = "Resize bigger vertically" })
vim.keymap.set('n', '<C-up>', ':resize -5<CR>', { desc = "Resize smaller vertically" })
vim.keymap.set('n', '<C-right>', ':vertical resize +5<CR>', { desc = "Resize bigger horizontally" })

-- Old habits
vim.keymap.set('i', 'jj', '<Esc>', { desc = "Escape" })

-- There are other worlds
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = "[Y]ank to other worlds" })
vim.keymap.set('n', '<leader>Y', 'gg"+yG', { desc = "[Y]ank buffer to other worlds" })
vim.keymap.set('x', '<leader>p', '"_dP', { desc = "[P]aste to the void" })
vim.keymap.set('n', '<leader>d', '"_d', { desc = "[D]elete to the void" })

-- Move lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move line down visually" })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move line up visually" })

-- `J` without moving cursor
vim.keymap.set('n', 'J', 'mzJ`z')

-- Keep things centered while moving
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Avoid `Q`
vim.keymap.set('n', 'Q', '<nop>')

-- Tmux-Sessionizer
vim.keymap.set('n', '<leader>ts', '<cmd>silent !tmux neww tmux-sessionizer<CR>', { desc = "[T]mux-[S]essionizer" })

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file e[X]ecutable" })

-- Show keymaps
vim.keymap.set("n", "<leader>sk", ":Telescope keymaps<CR>", { desc = "Telescope - [S]earch [K]eymaps" })

-- Choose YAML schema
vim.keymap.set("n", "<leader>sy", ":Telescope yaml_schema<CR>", { desc = "Telescope - [S]earch [Y]AML schema" })

-- PackerSync
vim.keymap.set("n", "<leader>ps", vim.cmd.PackerSync, { desc = "[P]acker[S]ync" })

-- Diff current windows
vim.keymap.set("n", "<leader>dt", ":windo diffthis<CR>", { desc = "[D]iff[T]his" })
vim.keymap.set("n", "<leader>du", ":diffoff<CR>", { desc = "[D]iff[O]ff" })

-- Nerdtree
vim.keymap.set("n", "<leader>nt", ":NERDTreeToggle<CR>", { desc = "[N]ERD[T]ree"} )

-- toggle conceallevel
vim.keymap.set("n", "<leader>tc", ":setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>", { desc = "[T]oggle [C]onceallevel"} )
