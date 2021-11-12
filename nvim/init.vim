filetype plugin indent on

syntax on

let mapleader = " "
let g:indenLine_setConceal=2

set nu rnu
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set noswapfile
set shell=/bin/zsh
set nohlsearch
set so=10
set incsearch
set nocompatible
set noshowmode
set hidden
let g:indentLine_fileTypeExclude = ['markdown']

if &term =~ '256color'
  set t_ut=
endif

nnoremap ' `
vnoremap ; :
vnoremap : ;
nnoremap ; :
nnoremap : ;

nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

nnoremap <c-left> :vertical resize -5<CR>
nnoremap <c-down> :resize +5<CR>
nnoremap <c-up> :resize -5<CR>
nnoremap <c-right> :vertical resize +5<CR>

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

" Spell check
set spelllang=en,fr
nnoremap <silent> <leader>s :set spell!<cr>
nnoremap <leader>sn ]s
nnoremap <leader>sp [s

" Automatically source `.vimrc` on save.
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

" Plugin

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'

Plug 'scrooloose/nerdtree'

Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-repeat'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-fugitive'

Plug 'easymotion/vim-easymotion'

Plug 'yggdroot/indentline'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

Plug 'sheerun/vim-polyglot'

Plug 'ThePrimeagen/harpoon'

Plug 'sbdchd/neoformat'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

call plug#end()

" Plug-in conf

"" easymotion

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" vim fugitive
nnoremap <leader>ga :Git fetch --all<CR>
nnoremap <leader>grum :Git rebase upstream/master<CR>
nnoremap <leader>grom :Git rebase origin/master<CR>

nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gs :G<CR>

" harpoon
nnoremap <leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>d :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>e :lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>

nnoremap <leader>j :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>k :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>l :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>; :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <leader>tu :lua require("harpoon.term").gotoTerminal(1)<CR>
nnoremap <leader>te :lua require("harpoon.term").gotoTerminal(2)<CR>
nnoremap <leader>cu :lua require("harpoon.term").sendCommand(1, 1)<CR>
nnoremap <leader>ce :lua require("harpoon.term").sendCommand(1, 2)<CR>

" nerdtree
" enable line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" Neoformat
nnoremap <leader>f :Neoformat<CR>
let g:neoformat_enabled_yaml = ['prettier']
let g:neoformat_enabled_markdown = ['prettier']
let g:neoformat_enabled_json = ['prettier']
let g:neoformat_enabled_go = ['gofmt']
let g:shfmt_opt="-ci"

lua << END
require'lualine'.setup{
  options = {
    theme = 'dracula',
    component_separators = '|',
    section_separators = { left = '', right = '' }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff',
                  {'diagnostics', sources={'nvim_lsp', 'coc'}}},
    lualine_c = {
      {
      'filename',
      file_status = true,
      path = 1,
      shorting_target = 40
      }
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
END

nnoremap <silent> <C-f> :silent !tmux neww tmux-sessionizer<CR>

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

command! TrimWhitespace call TrimWhitespace()

:noremap <leader>w :call TrimWhitespace()<CR>
