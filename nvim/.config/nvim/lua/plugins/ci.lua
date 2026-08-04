-- CI-only overrides. Empty in normal use.
--
-- The startup check in ci/check-nvim.sh loads every plugin spec and treats any
-- warning as a failure. It does not need language servers or treesitter parsers,
-- and installing them makes the run slow, network-dependent and noisy.

if not vim.env.CI then
  return {}
end

return {
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },

  {
    "nvim-treesitter/nvim-treesitter",
    -- The function form is required. LazyVim declares ensure_installed under
    -- opts_extend, so lists are appended rather than replaced: `opts = {
    -- ensure_installed = {} }` merges to nothing and the full parser list
    -- survives. Assigning inside the function replaces it outright.
    --
    -- Without this, dozens of parsers download during the startup check and any
    -- failure to fetch or compile one surfaces as a bare "Error in command line:".
    opts = function(_, opts)
      opts.ensure_installed = {}
      opts.auto_install = false
      return opts
    end,
  },
}
