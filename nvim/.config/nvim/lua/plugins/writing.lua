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
              additionalRules = {
                enablePickyRules = true,
                motherTongue = "fr",
              },
              -- LaTeX commands that take a non-prose argument, so the checker
              -- stops reporting them as sentence fragments.
              latex = {
                commands = { ["\\includegraphics[]{}"] = "ignore", ["\\lstinputlisting{}"] = "ignore" },
              },
              disabledRules = {
                ["en-GB"] = { "OXFORD_SPELLING_Z_NOT_S" },
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
      completion = {
        -- blink.cmp is LazyVim's completion engine now, not nvim-cmp.
        blink = true,
        min_chars = 2,
      },
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
      { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian quick switch" },
      { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Obsidian today" },
      { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Obsidian yesterday" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian backlinks" },
      { "<leader>of", "<cmd>Obsidian follow_link<cr>", desc = "Obsidian follow link" },
      { "<leader>ol", "<cmd>Obsidian link<cr>", mode = "v", desc = "Obsidian link selection" },
      { "<leader>oi", "<cmd>Obsidian paste_img<cr>", desc = "Obsidian paste image" },
    },
  },
}
