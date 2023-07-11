require("nap").setup({
  next_prefix = ",",
  prev_prefix = "<c-,>",
  next_repeat = "<c-n>",
  prev_repeat = "<c-p>"
})

require("nap").map("d", {
  next = { rhs = "<cmd>Lspsaga diagnostic_jump_next<cr>", opts = { desc = "Next [D]iagnostic" } },
  prev = { rhs = "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts = { desc = "Previous [D]iagnostic" } },
  mode = { "n", "v", "o" },
})

require("nap").map("h", {
  next = { rhs = "<cmd>Gitsigns next_hunk<cr>", opts = { desc = "Next diff [H]unk" } },
  prev = { rhs = "<cmd>Gitsigns prev_hunk<cr>", opts = { desc = "Previous diff [H]unk" } },
  mode = { "n", "v", "o" },
})
