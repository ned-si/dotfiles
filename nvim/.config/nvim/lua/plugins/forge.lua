-- Pull requests and issues.
--
-- Two forges, because personal work is on GitHub and work is on
-- bitbucket.org/WORKSPACE. octo.nvim covers GitHub and is mature. Bitbucket and
-- Jira come from atlas.nvim, which is the only plugin that does both.
--
-- Caveat worth knowing before relying on it: atlas.nvim's own README says it is
-- in early development and will have breaking changes. It is isolated in this
-- file for that reason, so deleting it costs nothing. The fallback is the
-- browser, or asking Kiro through the Bitbucket MCP that work-cli configures,
-- which needs no plugin at all.
--
-- Credentials come from the environment, never from this repo. Put them in
-- ~/.zshenv.local:
--   export ATLAS_BITBUCKET_USER=...      Atlassian account email
--   export ATLAS_BITBUCKET_TOKEN=...     Atlassian API token
--   export ATLAS_JIRA_URL=https://<site>.atlassian.net
--   export ATLAS_JIRA_USER=...
--   export ATLAS_JIRA_TOKEN=...

local function env(name)
  local value = vim.env[name]
  if value == nil or value == "" then
    return nil
  end
  return value
end

return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enable_builtin = true,
      picker = "snacks", -- LazyVim's default picker; telescope is not installed
      file_panel = { use_icons = true },
      mappings = {
        review_diff = {
          select_next_entry = { lhs = "<Tab>", desc = "next changed file" },
          select_prev_entry = { lhs = "<S-Tab>", desc = "previous changed file" },
        },
      },
    },
    config = function(_, opts)
      require("octo").setup(opts)
      vim.treesitter.language.register("markdown", "octo")
    end,
    keys = {
      { "<leader>Po", "<cmd>Octo<cr>", desc = "Octo (GitHub)" },
      { "<leader>Pp", "<cmd>Octo pr list<cr>", desc = "GitHub PRs" },
      { "<leader>Pi", "<cmd>Octo issue list<cr>", desc = "GitHub issues" },
    },
  },

  {
    "emrearmagan/atlas.nvim",
    -- Pinned to a tag rather than tracking HEAD, since upstream is explicit
    -- about breaking changes. Bump deliberately.
    version = "*",
    cmd = { "Atlas" },
    dependencies = {
      "MeanderingProgrammer/render-markdown.nvim", -- comes with lang.markdown
      "sindrets/diffview.nvim",
    },
    opts = function()
      return {
        pulls = {
          providers = {
            bitbucket = {
              workspace = "WORKSPACE",
              username = env("ATLAS_BITBUCKET_USER"),
              token = env("ATLAS_BITBUCKET_TOKEN"),
            },
            github = {}, -- reuses `gh auth`
          },
        },
        issues = {
          providers = {
            jira = {
              url = env("ATLAS_JIRA_URL"),
              username = env("ATLAS_JIRA_USER"),
              token = env("ATLAS_JIRA_TOKEN"),
            },
          },
        },
      }
    end,
    keys = {
      { "<leader>Pb", "<cmd>Atlas pulls bitbucket<cr>", desc = "Bitbucket PRs" },
      { "<leader>Pj", "<cmd>Atlas issues jira<cr>", desc = "Jira issues" },
    },
  },
}
