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

nnoremap <c-Left> :vertical resize -5<CR>
nnoremap <c-Down> :resize +5<CR>
nnoremap <c-Up> :resize -5<CR>
nnoremap <c-Right> :vertical resize +5<CR>

" Auto source .vimrc on save
augroup Vimrc
  autocmd! bufwritepost .vimrc source %
augroup END

" Plugin

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'

Plug 'scrooloose/nerdtree'

Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-repeat'

Plug 'tpope/vim-commentary'

Plug 'easymotion/vim-easymotion'

Plug 'yggdroot/indentline'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

call plug#end()

" Plugin confs

"" easymotion

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

"" Telescope

" Using lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
