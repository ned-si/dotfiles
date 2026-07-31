-- AI agent chat in the editor, over the Agent Client Protocol.
--
-- ACP lets an editor talk to any compatible agent CLI, so this reuses whatever
-- the CLI already has configured: its auth, its tool servers, its own skills and
-- sub-agents. Nothing is duplicated here and no additional service is involved,
-- so the model and data path are the same as using that CLI in a terminal.
--
-- Sessions are shared in both directions: a conversation started here can be
-- resumed from the terminal with `--resume`, and the other way round.
--
-- Set ACP_PROVIDER in ~/.zshenv.local to point at whichever agent CLI is
-- installed; the default below matches the one on this machine.
--
-- trust_all_tools is deliberately not set. Tool calls stay behind the plugin's
-- own permission prompt, which is worth keeping given the agent can read and
-- write the working tree.

return {
  {
    "carlos-algms/agentic.nvim",
    -- No cmd trigger: the plugin exposes no user commands, only a lua API, so
    -- the keymaps below are what load it. Each requires the module inside its
    -- own function, so nothing is pulled in at startup.
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
