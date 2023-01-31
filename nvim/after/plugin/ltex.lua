require'lspconfig'.ltex.setup {
  on_attach = function(client, bufnr)
    require("ltex_extra").setup{
        load_langs = { "fr-CH", "en-US", "en-GB" }, -- table <string> : languages for witch dictionaries will be loaded
        init_check = true, -- boolean : whether to load dictionaries on startup
        path = "$HOME/.local/share/nvim/.ltex", -- string : path to store dictionaries. Relative path uses current working directory
        log_level = "none", -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
    }
  end,
  settings = {
    ltex = {
    }
  }
}
