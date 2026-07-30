-- Kiro inside nvim.
--
-- `kiro-cli acp` runs Kiro as an Agent Client Protocol agent, and agentic.nvim is
-- an ACP client with kiro-acp as a built-in provider. Because it speaks ACP to
-- the same CLI you would run in a terminal, it inherits the existing setup
-- rather than duplicating it: the same auth, the same MCP servers that
-- `devops-cli ai mcp` manages, the same skills and sub-agents. Sessions are
-- interchangeable, so a conversation started here can be resumed with
-- `kiro-cli --resume` and the other way round.
--
-- Genesys has a sanctioned path for this too: `devops-cli ai acp init`.
--
-- Worth being deliberate about: this is a third-party plugin that brokers an AI
-- agent with filesystem access. Tool calls are gated behind agentic.nvim's
-- permission prompt below, and trust_all_tools is deliberately NOT set.

return {
  {
    "carlos-algms/agentic.nvim",
    cmd = { "Agentic" },
    opts = {
      provider = "kiro-acp",
    },
    keys = {
      {
        "<C-\\>",
        function()
          require("agentic").toggle()
        end,
        mode = { "n", "v", "i" },
        desc = "Toggle Kiro chat",
      },
      {
        "<leader>ka",
        function()
          require("agentic").add_selection_or_file_to_context()
        end,
        mode = { "n", "v" },
        desc = "Kiro: add file or selection to context",
      },
      {
        "<leader>kn",
        function()
          require("agentic").new_session()
        end,
        mode = { "n", "v" },
        desc = "Kiro: new session",
      },
      {
        "<leader>kr",
        function()
          require("agentic").restore_session()
        end,
        desc = "Kiro: restore session",
      },
    },
  },
}
