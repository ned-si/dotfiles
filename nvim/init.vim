filetype plugin indent on

syntax on

let mapleader = " "
let g:indenLine_setConceal=2

set nu rnu
set expandtab
set shiftwidth=2
set tabstop=2
set shell=/bin/zsh
set nohlsearch
set so=5
set incsearch
set nocompatible
set noshowmode
set hidden
set noswapfile
set colorcolumn=80
let g:indentLine_fileTypeExclude = ['markdown']
set modifiable

" colorscheme
let g:tokyonight_style = "night"
let g:tokyonight_transparent_sidebar = "true"
let g:tokyonight_transparent = "true"
let g:tokyonight_colors = { "bg_float" : "none" }
let g:dracula_transparent_bg = v:true
lua vim.opt.background = "dark"

colorscheme tokyonight

autocmd FileType go setlocal shiftwidth=4 expandtab! tabstop=4

if &term =~ '256color'
  set t_ut=
endif

" highlight Pmenu ctermbg=238 gui=bold "only needed when running default
" colorscheme

nnoremap ' `
vnoremap ; :
vnoremap : ;
nnoremap ; :
nnoremap : ;

inoremap jj <Esc>

tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
tnoremap <Esc> <C-\><C-N>
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
inoremap <C-h> <C-\><C-N><C-w>h
inoremap <C-j> <C-\><C-N><C-w>j
inoremap <C-k> <C-\><C-N><C-w>k
inoremap <C-l> <C-\><C-N><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

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
" zg to add word to dictionnary

" Automatically source `.vimrc` on save.
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

" telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files({hidden=true})<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep({hidden=true})<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fe <cmd>lua require('telescope.builtin').diagnostics()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>fs <cmd>Telescope yaml_schema<cr>

" dap: to test first by hand without Telescope
" nnoremap <leader>fdm <cmd>lua require('telescope.extensions.dap').commands()<cr>
" nnoremap <leader>fdc <cmd>lua require('telescope.extensions.dap').configurations()<cr>
" nnoremap <leader>fdb <cmd>lua require('telescope.extensions.dap').list_breakpoints()<cr>
" nnoremap <leader>fdv <cmd>lua require('telescope.extensions.dap').variables()<cr>
" nnoremap <leader>fdf <cmd>lua require('telescope.extensions.dap').frames()<cr>

set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" harpoon
nnoremap <leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>d :lua require("harpoon.ui").toggle_quick_menu()<CR>
" nnoremap <leader>e :lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>

nnoremap <leader>j :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>k :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>l :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>; :lua require("harpoon.ui").nav_file(4)<CR>
" nnoremap <leader>tu :lua require("harpoon.term").gotoTerminal(1)<CR>
" nnoremap <leader>te :lua require("harpoon.term").gotoTerminal(2)<CR>
nnoremap <leader>cu :lua require("harpoon.term").sendCommand(1, 1)<CR>
nnoremap <leader>ce :lua require("harpoon.term").sendCommand(1, 2)<CR>

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

command! TrimWhitespace call TrimWhitespace()

:noremap <leader>w :call TrimWhitespace()<CR>

"" lazygit
" setup mapping to call :LazyGit
nnoremap <silent> <leader>gg :LazyGit<CR>

" nvim-tree
nnoremap <leader>t :NvimTreeToggle<CR>

" easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

lua << EOF
require('plugins')
require('nvim-lsp-installer').setup{}
require('nvim-toggler')
EOF
