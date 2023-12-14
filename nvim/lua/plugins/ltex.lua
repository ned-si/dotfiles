return {
    "barreiroleo/ltex_extra.nvim",
    ft = { "markdown", "tex" },
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
        load_langs = { "fr-CH", "en-US", "en-GB" },
        init_check = true,
        path = "$HOME/.local/share/nvim/.ltex",
        server_opts = {
            capabilities = your_capabilities,
            on_attach = function(client, bufnr)
            end,
            settings = {
                ltex = {}
            }
        },
    }
}
