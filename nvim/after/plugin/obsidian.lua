require("obsidian").setup({
  dir = "~/braindump",
  completion = {
    nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
  },
  note_id_func = function(title)
    -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
    local suffix = ""
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      -- If title is nil, just add 4 random uppercase letters to the suffix.
      suffix = tostring(os.time())
    end
    return suffix
  end,
  notes_subdir = "notes",
  daily_notes = {
    folder = "notes/dailies",
  }
})

vim.keymap.set(
  "n",
  "gf",
  function()
    if require('obsidian').util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<CR>"
    else
      return "gf"
    end
  end,
  { noremap = false, expr = true}
)


vim.keymap.set("n", "<leader>ob", ":ObsidianBacklinks<CR>", { desc = "[O]bsidian [B]ack links" })
vim.keymap.set("n", "<leader>ot", ":ObsidianToday<CR>", { desc = "[O]bsidian [T]oday" })
vim.keymap.set("n", "<leader>oy", ":ObsidianYesterday<CR>", { desc = "[O]bsidian [Y]esterday" })
vim.keymap.set("n", "<leader>oo", ":ObsidianOpen<CR>", { desc = "[O]bsidian [O]pen" })
vim.keymap.set("n", "<leader>on", ":ObsidianNew ", { desc = "[O]bsidian [N]ew" })
vim.keymap.set("n", "<leader>os", ":ObsidianSearch<CR>", { desc = "[O]bsidian [S]earch" })
vim.keymap.set("n", "<leader>oq", ":ObsidianQuickSwitch<CR>", { desc = "[O]bsidian [Q]uickSwitch" })
vim.keymap.set("n", "<leader>ol", ":ObsidianLink ", { desc = "[O]bsidian [L]ink" })
vim.keymap.set("n", "<leader>oln", ":ObsidianLinkNew ", { desc = "[O]bsidian [L]ink [N]ew" })
vim.keymap.set("n", "<leader>of", ":ObsidianFollowLink<CR>", { desc = "[O]bsidian [F]ollow link" })
