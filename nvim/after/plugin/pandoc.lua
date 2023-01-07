require('pandoc').setup{
  commands = {
    name = 'PandocBuild'
  },
  default = {
    output = '%s.pdf'
  },
}

vim.keymap.set("n", "<leader>pe", vim.cmd.Pandoc, { desc = "[P]andoc [E]xport"})
