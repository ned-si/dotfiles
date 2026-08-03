-- Navigation and text-munging. This is the part of the old config that was
-- worth keeping verbatim.

return {
  -- Four pinned files per project, jumped to by position rather than by name.
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function()
      local h = function(fn)
        return function()
          fn(require("harpoon"))
        end
      end
      local select = function(n)
        return h(function(harpoon)
          harpoon:list():select(n)
        end)
      end
      local replace = function(n)
        return h(function(harpoon)
          harpoon:list():replace_at(n)
        end)
      end

      return {
        {
          "<leader>ha",
          h(function(hp)
            hp:list():add()
          end),
          desc = "Harpoon add",
        },
        {
          "<leader>hA",
          h(function(hp)
            hp:list():prepend()
          end),
          desc = "Harpoon prepend",
        },
        {
          "<leader>hg",
          h(function(hp)
            hp.ui:toggle_quick_menu(hp:list())
          end),
          desc = "Harpoon menu",
        },

        { "<leader>j", select(1), desc = "Harpoon 1" },
        { "<leader>k", select(2), desc = "Harpoon 2" },
        { "<leader>l", select(3), desc = "Harpoon 3" },
        { "<leader>;", select(4), desc = "Harpoon 4" },

        { "<leader><C-j>", replace(1), desc = "Harpoon replace 1" },
        { "<leader><C-k>", replace(2), desc = "Harpoon replace 2" },
        { "<leader><C-l>", replace(3), desc = "Harpoon replace 3" },
      }
    end,
    config = function()
      require("harpoon"):setup()
    end,
  },

  -- <leader>U rather than <leader>u: LazyVim owns <leader>u as its toggles
  -- group, and a direct mapping there would shadow all of them.
  {
    "mbbill/undotree",
    keys = {
      { "<leader>U", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
    },
  },

  {
    "nvim-mini/mini.surround",
    opts = {
      -- tpope/surround muscle memory rather than mini's defaults.
      mappings = {
        add = "ys",
        delete = "ds",
        replace = "cs",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        update_n_lines = "gsn",
      },
    },
  },

  { "nvim-mini/mini.align", version = false, opts = {} },

  {
    "nvim-mini/mini.trailspace",
    version = false,
    opts = {},
    keys = {
      {
        "<leader>tw",
        "<cmd>lua MiniTrailspace.trim()<cr>",
        desc = "Trim trailing whitespace",
      },
      {
        "<leader>tl",
        "<cmd>lua MiniTrailspace.trim_last_lines()<cr>",
        desc = "Trim trailing lines",
      },
    },
  },

  {
    "xorid/swap-split.nvim",
    keys = {
      {
        "<leader>ss",
        function()
          require("swap-split").swap()
        end,
        desc = "Swap split",
      },
    },
  },

  -- Open the current file or selection on the forge in a browser.
  {
    "almo7aya/openingh.nvim",
    keys = {
      { "<leader>ogr", "<cmd>OpenInGHRepo<cr>", desc = "Open repo in browser" },
      {
        "<leader>ogf",
        "<cmd>OpenInGHFile<cr>",
        mode = "n",
        desc = "Open file in browser",
      },
      {
        "<leader>ogf",
        "<cmd>OpenInGHFileLines<cr>",
        mode = "v",
        desc = "Open lines in browser",
      },
    },
  },

  -- Flip true/false, and check/uncheck markdown tasks.
  {
    "nguyenvukhang/nvim-toggler",
    opts = {
      inverses = {
        ["[ ]"] = "[x]",
        ["yes"] = "no",
        ["enable"] = "disable",
        ["enabled"] = "disabled",
      },
    },
  },

  -- Structural edits driven by treesitter, e.g. collapsing a multiline table.
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    opts = {},
    keys = {
      {
        "<leader>na",
        function()
          require("ts-node-action").node_action()
        end,
        desc = "Node action",
      },
    },
  },

  -- yazi replaces ranger: same modal feel, plus inline image previews. It is the
  -- only file browser here. No tree docked to the left, no picker sidebar; see
  -- plugins/disabled.lua for what was turned off to get there.
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>-", "<cmd>Yazi<cr>", desc = "yazi at current file" },
      { "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "yazi at cwd" },
    },
    opts = {
      -- Take over directory buffers, so `:e .` and `nvim <dir>` open yazi. This
      -- replaces a hand-rolled netrw autocmd: going through the plugin's own
      -- option avoids racing snacks and netrw over the FileExplorer augroup.
      --
      -- Note this also captures :Explore, so netrw is effectively out of the
      -- picture rather than sitting behind it as a fallback.
      open_for_directories = true,
      keymaps = { show_help = "<f1>" },
    },
  },

  -- Distraction-free writing, used with the prose filetypes.
  {
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        gitsigns = { enabled = true },
        tmux = { enabled = true },
        diagnostics = { enabled = true },
      },
    },
    keys = {
      { "<leader>zm", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
  },
  {
    "folke/twilight.nvim",
    opts = { dimming = { alpha = 0.4, inactive = true } },
    keys = {
      { "<leader>tt", "<cmd>Twilight<cr>", desc = "Toggle twilight" },
    },
  },

  -- Centre a single buffer on the ultrawide without tiling anything.
  {
    "shortcuts/no-neck-pain.nvim",
    cmd = "NoNeckPain",
    keys = {
      { "<leader>np", "<cmd>NoNeckPain<CR>", desc = "No neck pain" },
    },
  },
}
