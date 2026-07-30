-- Things LazyVim enables that are not wanted here.

return {
  -- mini.files (via the editor.mini-files extra) and yazi cover browsing; a
  -- third tree is one more set of keymaps to remember.
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  -- Auto-inserted closing pairs fight with surround-based editing.
  { "nvim-mini/mini.pairs", enabled = false },

  -- render-markdown.nvim already styles headings, so this duplicates it.
  { "lukas-reineke/headlines.nvim", enabled = false },
}
