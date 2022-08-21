if !exists('g:loaded_nvim_treesitter')
  finish
endif

lua << EOF
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
    },
  indent = {
    enable = false,
    disable = {},
    },
  ensure_installed = {
      "bash",
      "bibtex",
      "c",
      "comment",
      "dockerfile",
      "go",
      "hcl",
      "json",
      "latex",
      "lua",
      "markdown",
      "python",
      "regex",
      "rust",
      "rego",
      "sql",
      "vim",
      "yaml"
    },
    matchup = {
      enable = true,      -- mandatory, false will disable the whole extension
    }
  }
EOF
