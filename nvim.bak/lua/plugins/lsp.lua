return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        yamlls = {
          -- Have to add this for yamlls to understand that we support line folding
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
              schemas = {
                kubernetes = "*.yaml",
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
              },
            },
          },
        },
      },
    },
  },

  {
    "nvimdev/lspsaga.nvim",
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
        desc = "LSP: [C]ode [A]ction",
      },
      {
        "<leader>pd",
        "<cmd>Lspsaga peek_definition<CR>",
        desc = "LSP: [P]eak [D]efinition",
      },
      {
        "<leader>pt",
        "<cmd>Lspsaga peek_type_definition<CR>",
        desc = "LSP: [P]eak [T]ype definition",
      },
      {
        "<leader>cd",
        "<cmd>Lspsaga show_cursor_diagnostics<CR>",
        desc = "LSP: show [C]urrent [D]iagnostic",
      },
      {
        "<C-p>",
        "<cmd>Lspsaga diagnostic_jump_prev<CR>",
        desc = "LSP: Diagnostic [P]revious",
      },
      {
        "<C-n>",
        "<cmd>Lspsaga diagnostic_jump_next<CR>",
        desc = "LSP: Diagnostic [N]ext",
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
        desc = "LSP: Show [Ou]tline",
      },
      {
        "K",
        "<cmd>Lspsaga hover_doc<CR>",
        desc = "Hover Documentation",
      },
    },
  },
}
