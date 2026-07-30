-- lspsaga is gone. It was carried for two things: good-looking hover/peek
-- windows, and a diagnostic-jump keymap set. On nvim 0.12 the first is a border
-- option away and the second is native. It was also a startup error waiting to
-- happen, because its spec called require("catppuccin...lsp_saga") while the
-- spec table was still being evaluated, before catppuccin was on the rtp.
--
-- Peeking is the one thing with no native equivalent, so glance.nvim covers it.

-- Registered at module scope rather than inside a plugin's config(), which is
-- safe because it touches only core nvim API and no plugin needs to be loaded.
-- Buffer-local so these exist only where a server actually attached.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("dotfiles_lsp_keys", { clear = true }),
  callback = function(event)
    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or "n", lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map("K", function()
      vim.lsp.buf.hover({ border = "rounded" })
    end, "Hover documentation")

    map("<C-s>", function()
      vim.lsp.buf.signature_help({ border = "rounded" })
    end, "Signature help", "i")

    map("<leader>cd", function()
      vim.diagnostic.open_float({ border = "rounded", source = true })
    end, "Line diagnostics")

    -- Normal mode only: blink.cmp owns C-n/C-p while the completion menu is up.
    map("<C-n>", function()
      vim.diagnostic.jump({ count = 1, float = { border = "rounded" } })
    end, "Next diagnostic")
    map("<C-p>", function()
      vim.diagnostic.jump({ count = -1, float = { border = "rounded" } })
    end, "Previous diagnostic")

    map("[E", function()
      vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
    end, "Previous error")
    map("]E", function()
      vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
    end, "Next error")
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        float = { border = "rounded", source = true },
        severity_sort = true,
        virtual_text = { prefix = "●", spacing = 2 },
      },
    },
  },

  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    opts = {
      border = { enable = true },
      folds = { folded = true },
    },
    keys = {
      { "<leader>pd", "<cmd>Glance definitions<cr>", desc = "Peek definitions" },
      { "<leader>pt", "<cmd>Glance type_definitions<cr>", desc = "Peek type definitions" },
      { "<leader>pr", "<cmd>Glance references<cr>", desc = "Peek references" },
      { "<leader>pi", "<cmd>Glance implementations<cr>", desc = "Peek implementations" },
      { "gh", "<cmd>Glance references<cr>", desc = "Peek references" },
    },
  },
}
