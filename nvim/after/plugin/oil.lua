require("oil").setup({
  default_file_explorer = false,
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  },
  keymap = {
    ["<C-s>"] = "actions.select_split",
    ["<C-v>"] = "actions.select_vsplit",
  }
})


vim.keymap.set("n", "<leader>oe", ":Oil .<CR>", { desc = "[O]il [E]dit" })
