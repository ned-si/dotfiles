require("oil").setup({
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = false,
  },
})


vim.keymap.set("n", "<leader>oe", ":Oil .<CR>", { desc = "[O]il [E]dit" })
