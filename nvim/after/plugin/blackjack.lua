require("blackjack").setup({
  card_style = "mini", -- Can be "mini" or "large".
  suit_style = "black", -- Can be "black" or "white".
  scores_path = "$HOME/.blackjack_scores.json", -- Default location to store the scores.json file.
})


vim.keymap.set("n", "<leader>bj", ":BlackJackNewGame<CR>", { desc = "[B]lack[J]ack" })
