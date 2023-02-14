require("nap").setup({
  next_prefix = "<cr>",
  prev_prefix = "<c-cr>",
  next_repeat = "<c-n>",
  prev_repeat = "<c-p>"
})

require("nap").nap('h', "Gitsigns next_hunk", "Gitsigns prev_hunk", "Next diff [H]unk", "Previous diff [H]unk")
require("nap").nap('d', "Lspsaga diagnostic_jump_next", "Lspsaga diagnostic_jump_prev", "Next [D]iagnostic", "Previous [D]iagnostic")
