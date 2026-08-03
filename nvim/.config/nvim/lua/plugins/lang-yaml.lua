-- Why the old YAML setup fell over, since this is the part that has to be right.
--
-- Three plugins were configuring the same language server at once: a hand-written
-- yamlls block, yaml-companion.nvim (which reconfigures yamlls itself), and
-- yaml.nvim. On top of that, `kubernetes = "*.yaml"` applied the Kubernetes
-- schema to every YAML file that was ever opened, which is what produced the
-- flood of bogus diagnostics on ordinary config files, and the
-- "Cannot read properties of undefined (reading 'length')" errors from the
-- server when a document did not look like a manifest at all.
--
-- The hand-written block also used on_new_config, which no longer exists: it was
-- removed when nvim moved to the vim.lsp.config API in 0.11, so on 0.12 that
-- code path was simply dead and the schemas it set were never applied.
--
-- So: exactly one thing configures yamlls now, that being LazyVim's lang.yaml
-- extra plus the override below. Kubernetes is matched on paths that plausibly
-- hold manifests rather than on every .yaml, with <leader>cyK to pin it when
-- the guess is wrong. Actual manifest validation is kubeconform's job, not the
-- schema engine's.
--
-- Helm is a separate problem and gets a separate server. Go templates are not
-- valid YAML, so yamlls reports every {{ }} as a syntax error; the lang.helm
-- extra hands those buffers to helm-ls instead. That was the other reliable way
-- to make the old config unusable.

local kubernetes_globs = {
  "**/k8s/**/*.{yml,yaml}",
  "**/kube/**/*.{yml,yaml}",
  "**/kubernetes/**/*.{yml,yaml}",
  "**/manifests/**/*.{yml,yaml}",
  "**/overlays/**/*.{yml,yaml}",
  "**/base/**/*.{yml,yaml}",
  "*.k8s.{yml,yaml}",
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          -- yamlls needs telling that this client only folds by line.
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              -- Alphabetical key order is not a real problem.
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              -- schemastore.nvim supplies the catalogue instead, so the
              -- built-in store must be off or the two fight.
              schemaStore = { enable = false, url = "" },
              schemas = {
                kubernetes = kubernetes_globs,
                ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
                ["https://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
                ["https://json.schemastore.org/dependabot-2.0.json"] = ".github/dependabot.{yml,yaml}",
                ["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
                ["https://json.schemastore.org/chart.json"] = "Chart.{yml,yaml}",
                ["https://json.schemastore.org/pre-commit-config.json"] = ".pre-commit-config.{yml,yaml}",
                ["https://json.schemastore.org/gitlab-ci.json"] = "*gitlab-ci*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = "*play*.{yml,yaml}",
              },
            },
          },
        },
      },
    },
  },

  -- Real Kubernetes validation, including CRDs, which a JSON schema alone will
  -- not give you. Runs on write rather than on every keystroke because it shells
  -- out and hits a schema cache.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}

      opts.linters = opts.linters or {}
      opts.linters.kubeconform = {
        cmd = "kubeconform",
        stdin = true,
        args = {
          "-strict",
          "-summary",
          "-output",
          "json",
          -- Fall back to the CRD catalogue for anything not in the core schemas,
          -- otherwise every custom resource reports as unknown.
          "-schema-location",
          "default",
          "-schema-location",
          "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json",
          "-ignore-missing-schemas",
          "-",
        },
        stream = "stdout",
        ignore_exitcode = true,
        parser = function(output)
          local diagnostics = {}
          if output == nil or output == "" then
            return diagnostics
          end
          local ok, decoded = pcall(vim.json.decode, output)
          if not ok or type(decoded) ~= "table" or not decoded.resources then
            return diagnostics
          end
          for _, resource in ipairs(decoded.resources) do
            if
              resource.status == "statusInvalid"
              or resource.status == "statusError"
            then
              table.insert(diagnostics, {
                lnum = 0,
                col = 0,
                severity = vim.diagnostic.severity.WARN,
                source = "kubeconform",
                message = resource.msg or "invalid manifest",
              })
            end
          end
          return diagnostics
        end,
      }

      return opts
    end,
  },

  -- Navigating deep manifests by key path. Deliberately does not touch the LSP,
  -- unlike the yaml plugins this replaces.
  {
    "cuducos/yaml.nvim",
    ft = { "yaml", "helm" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- Bound under <leader>cy, not <leader>y: <leader>y is an operator ("+y), so
    -- <leader>yy already means "yank this line to the system clipboard".
    keys = {
      { "<leader>cyv", "<cmd>YAMLView<cr>", desc = "YAML: view key path" },
      { "<leader>cyy", "<cmd>YAMLYank<cr>", desc = "YAML: yank value" },
      { "<leader>cyk", "<cmd>YAMLYankKey<cr>", desc = "YAML: yank key path" },
      {
        "<leader>cyq",
        "<cmd>YAMLQuickfix<cr>",
        desc = "YAML: keys to quickfix",
      },
    },
  },

  -- Escape hatch for when the path globs above guess wrong. yamlls honours an
  -- inline modeline, which beats reaching for a schema picker and survives being
  -- committed alongside the manifest.
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "<leader>cyK",
        function()
          local modeline = "# yaml-language-server: $schema=kubernetes"
          local first = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
          if first:match("yaml%-language%-server:") then
            vim.api.nvim_buf_set_lines(0, 0, 1, false, { modeline })
          else
            vim.api.nvim_buf_set_lines(0, 0, 0, false, { modeline })
          end
          vim.notify(
            "Pinned buffer to the Kubernetes schema",
            vim.log.levels.INFO
          )
        end,
        ft = { "yaml" },
        desc = "YAML: pin Kubernetes schema",
      },
    },
  },
}
