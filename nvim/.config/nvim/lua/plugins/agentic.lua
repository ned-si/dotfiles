-- AI agent chat in the editor, over the Agent Client Protocol.
--
-- ACP lets an editor talk to any compatible agent CLI, so this reuses whatever
-- the CLI already has configured: its auth, its tool servers, its own skills.
-- Sessions are shared in both directions, so a conversation started here can be
-- resumed from the terminal and vice versa.
--
-- DISABLED BY DEFAULT.
--
-- Two reasons, both worth re-checking before enabling:
--
--  1. Editor choice. Some environments only sanction specific editors for AI
--     assistance, and neovim is often not on that list. Check before using this
--     for anything other than personal work.
--  2. It is third-party code with filesystem access, brokering an agent that can
--     read and write the working tree. That warrants a dependency and static
--     analysis pass, and ideally a review of the plugin itself, rather than
--     being taken on trust.
--
-- The model and data path are the less interesting part of the risk: it proxies
-- to a CLI already installed and configured locally, so no additional service
-- receives anything. The composition is what deserves scrutiny.
--
-- Set the provider to match whichever agent CLI is installed. Flip enabled to
-- true once the above is settled. trust_all_tools is deliberately not set, so
-- tool calls stay behind the plugin's own permission prompt.

return {
  {
    "carlos-algms/agentic.nvim",
    enabled = false,
    cmd = { "Agentic" },
    opts = {
      provider = vim.env.ACP_PROVIDER or "kiro-acp",
    },
    keys = {
      {
        "<C-\\>",
        function()
          require("agentic").toggle()
        end,
        mode = { "n", "v", "i" },
        desc = "Toggle agent chat",
      },
      {
        "<leader>ka",
        function()
          require("agentic").add_selection_or_file_to_context()
        end,
        mode = { "n", "v" },
        desc = "Agent: add file or selection to context",
      },
      {
        "<leader>kn",
        function()
          require("agentic").new_session()
        end,
        mode = { "n", "v" },
        desc = "Agent: new session",
      },
      {
        "<leader>kr",
        function()
          require("agentic").restore_session()
        end,
        desc = "Agent: restore session",
      },
    },
  },
}
