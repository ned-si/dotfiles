-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local use = require('packer').use
return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'


  -- themes
  use 'folke/tokyonight.nvim'
  use 'Mofiqul/dracula.nvim'

  -- general
  use({
    "kylechui/nvim-surround",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  })
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
      },
      tag = 'nightly', -- optional, updated every week. (see issue #1193)
  }
  use 'tpope/vim-repeat'
  use 'yggdroot/indentline'
  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
    end
  }
  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
    }

  -- git
  use 'lewis6991/gitsigns.nvim'

  -- telescope stuff
  use 'nvim-lua/popup.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/plenary.nvim'}, { "kdheepak/lazygit.nvim" } },
    config = function()
        require("telescope").load_extension("lazygit")
        require('telescope').load_extension('fzy_native')
    end,
  }
  use 'nvim-telescope/telescope-fzy-native.nvim'

  -- lsp
  use {
    "williamboman/nvim-lsp-installer",
    "neovim/nvim-lspconfig",
  }
  use 'tami5/lspsaga.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-cmdline'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'tamago324/cmp-zsh'

  use 'onsails/lspkind-nvim'

  use 'ThePrimeagen/harpoon'

  use 'cohama/lexima.vim'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use {
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use 'xuhdev/vim-latex-live-preview'
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

  use 'kdheepak/lazygit.nvim'

  use({'ckipp01/nvim-jenkinsfile-linter', requires = { "nvim-lua/plenary.nvim" } })

  use 'towolf/vim-helm'

  use {
    "someone-stole-my-name/yaml-companion.nvim",
    requires = {
        { "neovim/nvim-lspconfig" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
  }

  use 'barreiroleo/ltex-extra.nvim'

  use 'junegunn/vim-easy-align'

  use 'andymass/vim-matchup'

  -- debugger
  use 'mfussenegger/nvim-dap'

  -- git worktree
  use 'ThePrimeagen/git-worktree.nvim'

  -- toggle stuff
  use { 'nguyenvukhang/nvim-toggler' }

end)
