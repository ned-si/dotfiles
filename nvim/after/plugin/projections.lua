require("projections").setup({ -- FIX: make this work with manually added workspaces only
    { "$HOME/personal/repos", {} },
    { "$HOME/work/repos", {} },
    { "$HOME/work/projects", {} },
  },
  workspaces_file = "$HOME/.projections/workspaces.json",
  sessions_directory = "$HOME/.projections/sessions",
})

-- Autostore session on VimExit
local Session = require("projections.session")
vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
  callback = function() Session.store(vim.loop.cwd()) end,
})

-- Switch to project if vim was started in a project dir
local switcher = require("projections.switcher")
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    if vim.fn.argc() == 0 then switcher.switch(vim.loop.cwd()) end
  end,
})

local Session = require("projections.session")
vim.api.nvim_create_user_command("StoreProjectSession", function()
  Session.store(vim.loop.cwd())
end, {})

vim.api.nvim_create_user_command("RestoreProjectSession", function()
  Session.restore(vim.loop.cwd())
end, {})

local Workspace = require("projections.workspace")
-- Add workspace command
vim.api.nvim_create_user_command("AddWorkspace", function()
  Workspace.add(vim.loop.cwd())
end, {})

vim.opt.sessionoptions:append("localoptions") -- Save localoptions to session file

-- Bind <leader>fp to Telescope projections
require('telescope').load_extension('projections')
vim.keymap.set("n", "<leader>pf", function() vim.cmd("Telescope projections") end, { desc = '[P]rojection [F]ind' } )

vim.keymap.set("n", "<leader>ps", vim.cmd.StoreProjectSession, { desc = '[P]rojection [S]tore session' })
vim.keymap.set("n", "<leader>pr", vim.cmd.RestoreProjectSession, { desc = '[P]rojection [R]estore session' })
vim.keymap.set("n", "<leader>pa", vim.cmd.AddWorkspace, { desc = '[P]rojection [A]dd workspace' })
