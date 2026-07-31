-- Things LazyVim enables that are not wanted here.

return {
  -- No sidebar file tree, in any form. Navigation is yazi (<leader>-) for
  -- browsing with previews, or netrw via `:e .` for a plain listing in the
  -- current window. Nothing docked to the left.
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "nvim-mini/mini.files", enabled = false },

  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        -- Without this snacks takes over netrw, so `:e .` opens its picker in a
        -- left split instead of a normal netrw buffer. That is the sidebar.
        enabled = false,
        replace_netrw = false,
      },
    },
    -- LazyVim's picker extra binds these to the explorer. Freed rather than
    -- left pointing at something disabled.
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
    },
  },

  -- Auto-inserted closing pairs fight with surround-based editing.
  { "nvim-mini/mini.pairs", enabled = false },

  -- render-markdown.nvim already styles headings, so this duplicates it.
  { "lukas-reineke/headlines.nvim", enabled = false },
}
