-- CI-only overrides. Empty in normal use.
--
-- The startup check in ci/check-nvim.sh wants to load every plugin spec and read
-- the warnings, but it does not need language servers. Left enabled, mason would
-- pull several hundred megabytes on every run, most of it ltex-ls-plus, and the
-- check would be slow and flaky for no extra coverage.

if not vim.env.CI then
  return {}
end

return {
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  -- Downloads a treesitter parser set on first run; the specs are still checked.
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
}
