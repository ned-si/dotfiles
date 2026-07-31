-- Colourscheme and statusline. Matches tmux, ghostty and lazygit, all of which
-- are on Catppuccin Mocha.

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      -- Ghostty is configured with a background, so let it show through.
      transparent_background = true,
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        indent_blankline = { enabled = true },
        mini = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        snacks = true,
        treesitter = true,
        which_key = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = vim.tbl_extend("force", opts.options or {}, {
        -- Not "catppuccin": there is no such theme file. catppuccin ships one
        -- per flavour (catppuccin-mocha, -latte, ...) plus catppuccin-nvim,
        -- which follows whichever flavour is configured above. Using the wrong
        -- name makes lualine warn and silently fall back to "auto".
        theme = "catppuccin-nvim",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      })

      -- Word count, but only where it means something.
      table.insert(opts.sections.lualine_x, 1, {
        function()
          local wc = vim.fn.wordcount()
          local n = wc.visual_words or wc.words
          return n .. (n == 1 and " word" or " words")
        end,
        cond = function()
          return vim.tbl_contains({ "markdown", "text", "tex", "plaintex" }, vim.bo.filetype)
        end,
      })

      return opts
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "┊" },
      scope = { enabled = false },
    },
  },

  {
    "snacks.nvim",
    opts = {
      -- Smooth scrolling fights with the centre-the-cursor mappings.
      scroll = { enabled = false },
      -- Image previews work because tmux has allow-passthrough on and Ghostty
      -- speaks the Kitty graphics protocol.
      image = { enabled = true },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      -- The LSP progress spinner is noise once a project is warm.
      lsp = { progress = { enabled = false } },
    },
  },
}
