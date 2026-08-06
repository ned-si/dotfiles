-- LaTeX, grammar checking and the Obsidian vault.

return {
  -- vimtex over LazyVim's texlab-only default: it owns the compile loop, the
  -- viewer handshake and the LaTeX-aware motions, none of which a language
  -- server does. texlab still attaches for completion via the lang.tex extra.
  {
    "lervag/vimtex",
    lazy = false, -- vimtex does its own ftplugin lazy-loading
    init = function()
      -- latexmk watches and rebuilds; -pdf so SyncTeX works both ways.
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "build",
        out_dir = "build",
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      -- Skim is the only macOS viewer with working reverse SyncTeX, i.e.
      -- cmd-shift-click in the PDF jumps to the source line in this nvim.
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1

      -- The quickfix list is unusable if every underfull hbox lands in it.
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull",
        "Overfull",
        "Package hyperref Warning",
        "Font shape",
      }

      vim.g.vimtex_mappings_prefix = "<localleader>"
    end,
  },

  -- Grammar and style for prose. ltex-ls itself is abandoned; ltex-ls-plus is
  -- the maintained fork and is what mason installs under this name.
  --
  -- It is a ~300MB LanguageTool bundle on the JVM, so expect 30 to 45 seconds
  -- before it attaches to the first prose buffer of a session. That is the cost
  -- of multilingual checking; harper-ls starts instantly but is English-only.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ltex_plus = {
          filetypes = { "markdown", "tex", "plaintex", "bib", "gitcommit" },
          settings = {
            ltex = {
              -- Swiss French plus both English variants, matching what actually
              -- gets written here.
              language = "en-GB",
              dictionary = (function()
                local path = vim.env.HOME
                  .. "/.ltex/dictionaries/dictionary.json"
                local f = io.open(path, "r")
                if f then
                  local ok, data = pcall(vim.json.decode, f:read("*a"))
                  f:close()
                  if ok then
                    return data
                  end
                end
                return {}
              end)(),
              additionalRules = {
                enablePickyRules = true,
                -- motherTongue is what enables LanguageTool's false-friend
                -- notes. Dropping it disables that whole class at once, which is
                -- the lever to reach for if the disabledRules list below starts
                -- growing.
                motherTongue = "fr",
              },
              -- LaTeX commands that take a non-prose argument, so the checker
              -- stops reporting them as sentence fragments.
              latex = {
                commands = {
                  ["\\includegraphics[]{}"] = "ignore",
                  ["\\lstinputlisting{}"] = "ignore",
                },
              },
              -- Applied per language, so a rule has to be listed under each one
              -- that is actually written in here.
              --
              -- REGARD and CHANGE are false-friend notes: with motherTongue set to
              -- French they claim "regard" means "considérer" and "change" means
              -- "monnaie". Both are wrong every time in normal English usage. The
              -- rule ID comes from the diagnostic's `code` field, which is how to
              -- find any others worth disabling.
              disabledRules = {
                ["en-GB"] = { "OXFORD_SPELLING_Z_NOT_S", "REGARD", "CHANGE" },
                ["en-US"] = { "REGARD", "CHANGE" },
                ["fr"] = { "REGARD", "CHANGE" },
              },
            },
          },
        },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ltex-ls-plus" })
      return opts
    end,
  },

  -- markdownlint-cli2 only looks for config in the linted file's directory and
  -- its ancestors: there is no XDG location, so a file opened outside a project
  -- gets stock defaults. Passing --config supplies a global baseline.
  --
  -- Scope worth knowing: despite --config being documented as the "base"
  -- configuration, a project-local .markdownlint.yaml does NOT merge with it, it
  -- replaces the rule settings. Verified: with a local config present the rules
  -- disabled globally start firing again. So this covers loose files and any
  -- project without its own config, and a project that has one wins outright,
  -- which is the reasonable outcome anyway.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters = opts.linters or {}
      local cfg = vim.fn.expand("~/.config/markdownlint/config.yaml")
      if vim.uv.fs_stat(cfg) then
        opts.linters["markdownlint-cli2"] = vim.tbl_deep_extend(
          "force",
          opts.linters["markdownlint-cli2"] or {},
          {
            args = { "--config", cfg, "--" },
          }
        )
      end
      return opts
    end,
  },

  -- "Add to dictionary" and friends are not part of LSP. The server offers them
  -- as code actions but leaves the actual work to the client, which is why they
  -- failed with "does not support command `_ltex.addToDictionary`": nothing was
  -- implementing them. This plugin does.
  --
  -- Chosen over barreiroleo/ltex_extra.nvim, which is what the old config used.
  -- That one still targets the archived ltex-ls, calls lspconfig["ltex"].setup
  -- itself, and is flagged a work in progress pending a rewrite. This one is
  -- written for ltex-ls-plus specifically.
  {
    "icewind/ltex-client.nvim",
    ft = { "markdown", "tex", "plaintex", "bib", "gitcommit" },
    opts = {
      -- Outside the repo on purpose, and deliberately not a stow package.
      -- Dictionaries accumulate project names, people and internal terms over
      -- time, none of which belongs in a public repo. Also matched by the global
      -- gitignore, in case it ever ends up somewhere tracked.
      --
      -- Writes dictionary.json, disabled_rules.json and false_positives.json,
      -- keyed by language, so one location serves every language.
      user_dictionaries_path = vim.env.HOME .. "/.ltex/dictionaries",
    },
  },

  -- epwalsh/obsidian.nvim is archived; this is the community fork that took over,
  -- and its options are not the same shape as the old one.
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      legacy_commands = false,
      workspaces = {
        { name = "braindump", path = "~/braindump" },
      },
      notes_subdir = "notes",
      daily_notes = {
        folder = "notes/dailies",
      },
      -- No completion block: obsidian.nvim ships its own obsidian-ls server now
      -- and warns that configuring completion here will be removed in 4.0.
      -- Titles become the filename, rather than a zettelkasten timestamp.
      note_id_func = function(title)
        if title ~= nil and title ~= "" then
          return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        end
        return tostring(os.time())
      end,
      ui = {
        -- render-markdown.nvim comes with the lang.markdown extra and does this
        -- better; two renderers fighting produces flicker.
        enable = false,
      },
    },
    keys = {
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian new" },
      { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Obsidian open in app" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Obsidian search" },
      {
        "<leader>oq",
        "<cmd>Obsidian quick_switch<cr>",
        desc = "Obsidian quick switch",
      },
      { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Obsidian today" },
      {
        "<leader>oy",
        "<cmd>Obsidian yesterday<cr>",
        desc = "Obsidian yesterday",
      },
      {
        "<leader>ob",
        "<cmd>Obsidian backlinks<cr>",
        desc = "Obsidian backlinks",
      },
      {
        "<leader>of",
        "<cmd>Obsidian follow_link<cr>",
        desc = "Obsidian follow link",
      },
      {
        "<leader>ol",
        "<cmd>Obsidian link<cr>",
        mode = "v",
        desc = "Obsidian link selection",
      },
      {
        "<leader>oi",
        "<cmd>Obsidian paste_img<cr>",
        desc = "Obsidian paste image",
      },
    },
  },
}
