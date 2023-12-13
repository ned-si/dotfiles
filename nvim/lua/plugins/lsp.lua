return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping =
        cmp.mapping.preset.insert(vim.tbl_deep_extend("force", opts.mapping, {
          ["<CR>"] = cmp.config.disable,
          ["C-y"] = cmp.mapping.confirm({ select = true }),
        }))
      return opts
    end,
  },

  {
    "nvimdev/lspsaga.nvim",
    lazy = true,
    opts = {
      definition = {
        keys = {
          edit = "<C-c>o",
          vsplit = "<C-c>v",
          split = "<C-c>s",
          tabe = "<C-c>t",
          quit = "q",
        },
      },
      ui = {
        border = "single",
        colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
        kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
      },
    },
    keys = {
      { "gh", "<cmd>Lspsaga finder<CR>", desc = "LSP: [G]et [H]elp" },
      {
        "<leader>ca",
        mode = { "n", "v" },
        "<cmd>Lspsaga code_action<CR>",
        { desc = "LSP: [C]ode [A]ction" },
      },
      {
        "gd",
        "<cmd>Lspsaga peek_definition<CR>",
        { desc = "LSP: [G]oto [D]efinition" },
      },
      {
        "gt",
        "<cmd>Lspsaga peek_type_definition<CR>",
        { desc = "LSP: [G]oto [T]ype definition" },
      },
      {
        "<leader>cd",
        "<cmd>Lspsaga show_cursor_diagnostics<CR>",
        { desc = "LSP: show [C]urrent [D]iagnostic" },
      },
      {
        "<C-p>",
        "<cmd>Lspsaga diagnostic_jump_prev<CR>",
        { desc = "LSP: Diagnostic [P]revious" },
      },
      {
        "<C-n>",
        "<cmd>Lspsaga diagnostic_jump_next<CR>",
        { desc = "LSP: Diagnostic [N]ext" },
      },
      {
        "[E",
        function()
          require("lspsaga.diagnostic"):goto_prev({
            severity = vim.diagnostic.severity.ERROR,
          })
        end,
      },
      {
        "<leader>ou",
        "<cmd>Lspsaga outline<CR>",
        { desc = "LSP: Show [Ou]tline" },
      },
      {
        "K",
        "<cmd>Lspsaga hover_doc<CR>",
        { desc = "Hover Documentation" },
      },
    },
  },
}
