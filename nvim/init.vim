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
let g:indentLine_fileTypeExclude = ['markdown']

autocmd FileType go setlocal shiftwidth=4 expandtab! tabstop=4

if &term =~ '256color'
  set t_ut=
endif

nnoremap ' `
vnoremap ; :
vnoremap : ;
nnoremap ; :
nnoremap : ;

inoremap jj <Esc>

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

" vimdiff
nnoremap <leader>dn ]c
nnoremap <leader>dp [c

" Automatically source `.vimrc` on save.
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

"" easymotion

nmap s <Plug>(easymotion-overwin-f2)

" telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fe <cmd>lua require('telescope.builtin').diagnostics()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>fs <cmd>Telescope yaml_schema<cr>

" vim fugitive
nnoremap <leader>gs :G<CR>
nnoremap <leader>ga :Git fetch --all<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>grum :Git rebase upstream/master<CR>
nnoremap <leader>grom :Git rebase origin/master<CR>

set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

nnoremap <leader>dj :diffget //3<CR>
nnoremap <leader>df :diffget //2<CR>
nnoremap <leader>ds :G<CR>

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

" Plugin stuff

lua << EOF
require('plugins')
require("nvim-lsp-installer").setup{}
EOF
