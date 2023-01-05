vim.cmd.packadd('packer.nvim')

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',

    },
  }

  -- Color matching things
  use 'andymass/vim-matchup'

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'
  use 'kdheepak/lazygit.nvim'

  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Helm
  use 'towolf/vim-helm' -- FIX: fix this! Currently not working at all

  -- Jenkins
  use({'ckipp01/nvim-jenkinsfile-linter', requires = { "nvim-lua/plenary.nvim" } }) -- FIX: fix this! Currently not working at all

  -- YAML
  use {
    "someone-stole-my-name/yaml-companion.nvim", --TODO: working, but can't use diagnostics related stuff OR the diagnostics are broken, to re test
    requires = {
        { "neovim/nvim-lspconfig" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
  }

  -- Learn to speak properly
  use 'barreiroleo/ltex-extra.nvim'


  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- File navigation in projects
  use 'theprimeagen/harpoon'

  -- Long-lasting undos
  use 'mbbill/undotree'

  -- Themes
  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use 'folke/tokyonight.nvim'
  use 'Mofiqul/dracula.nvim'

  -- Surrounds
  use 'kylechui/nvim-surround'

  -- (Nerd)Tree navigation
  use 'preservim/nerdtree'
  use 'PhilRunninger/nerdtree-buffer-ops'
  use 'Xuyuanp/nerdtree-git-plugin'

  -- Preview markdown
  use({ 'toppair/peek.nvim', run = 'deno task --quiet build:fast' })

  -- Debugger TODO: maybe implement that one day 
  -- use 'mfussenegger/nvim-dap'

  -- Git worktree
  use 'ThePrimeagen/git-worktree.nvim'

  -- Toggle stuff
  use {'nguyenvukhang/nvim-toggler'}

  -- Correct typos when opening files
  use "mong8se/actually.nvim"

  -- fancy renaming in scope using LSP
  use "smjonas/inc-rename.nvim"

  -- JSON query tester
  use 'gennaro-tedesco/nvim-jqx'

  -- Open Github project
  use "almo7aya/openingh.nvim"

  -- Templates everywhere!
  -- use {'glepnir/template.nvim'} -- TODO: make it work or use another one...
  use { 'cvigilv/esqueleto.nvim', branch = "develop" }

  -- Cute things
  use 'nvim-zh/colorful-winsep.nvim'
  use {
  "folke/todo-comments.nvim",
  requires = "nvim-lua/plenary.nvim"
}
  use 'rcarriga/nvim-notify'
  -- use({ -- NOTE: not sure I want this
  --   "folke/noice.nvim",
  --   requires = {
  --     "MunifTanjim/nui.nvim",
  --     "rcarriga/nvim-notify",
  --   }
  -- })

  -- What's the keybinding?
  use "folke/which-key.nvim"

  -- Swap splits
  use 'xorid/swap-split.nvim'

  -- Center buffer
  use {"shortcuts/no-neck-pain.nvim"}

  -- ChatGPT integration
  use({
  "jackMort/ChatGPT.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
})
  use 'aduros/ai.vim'

  -- Session management
  use 'gnikdroy/projections.nvim'

  -- Pandoc integration
  use 'aspeddro/pandoc.nvim' -- TODO: set this up properly

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end
