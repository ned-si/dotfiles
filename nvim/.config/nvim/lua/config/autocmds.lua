-- LazyVim's own autocmds are loaded first. Remove one by group name if needed,
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell").

local function augroup(name)
  return vim.api.nvim_create_augroup("dotfiles_" .. name, { clear = true })
end

-- Jenkinsfiles are Groovy but almost never named *.groovy. Covers Jenkinsfile,
-- Jenkinsfile.release, deploy.jenkinsfile and vars/*.groovy alike.
vim.filetype.add({
  filename = {
    ["Jenkinsfile"] = "groovy",
    ["jenkinsfile"] = "groovy",
  },
  pattern = {
    [".*[jJ]enkinsfile.*"] = "groovy",
  },
  extension = {
    jenkinsfile = "groovy",
    -- LilyPond include files.
    ily = "lilypond",
  },
})

-- work terraform lives in .tf; also treat .tfvars.json as json rather than
-- leaving it unhighlighted.
vim.filetype.add({
  extension = {
    tfvars = "terraform-vars",
  },
})

-- Prose wraps at the text width and gets spell checking; code does not. This is
-- the one place spelling is enabled, since opt.spell is off globally.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "tex", "plaintex", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us,fr"
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- YAML is whitespace-significant enough that a stray tab is a real bug.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("yaml_indent"),
  pattern = { "yaml", "yaml.docker-compose", "helm" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.indentkeys:remove("0#")
  end,
})

-- Python at work is 4-space, unlike the 2-space default set in options.lua.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("python_indent"),
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.colorcolumn = "88" -- ruff's default line length
  end,
})
