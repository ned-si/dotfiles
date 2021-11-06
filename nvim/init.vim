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

" Automatically source vimrc on save.
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

call plug#end()

" Plug-in conf

"" easymotion

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" vim fugitive
nnoremap <leader>ga :Git fetch --all<CR>
nnoremap <leader>grum :Git rebase upstream/master<CR>
nnoremap <leader>grom :Git rebase origin/master<CR>

nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gs :G<CR> #this doesn't work for some reason
