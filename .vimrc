" VIMRC

" Basics {{{
filetype plugin indent on         " Add filetype, plugin, and indent support
syntax on                         " Turn on syntax highlighting
set number relativenumber	  " Turn on relative numbers
set background=dark		  " Turn on dark background
colorscheme gruvbox		  " gruvbox theme
set mouse=a			  " mouse mode, just in case
if &term =~ '256color'		  " fix colors
    set t_ut=
  endif
"}}}

" Settings {{{
set shell=/usr/bin/zsh            " Prefer zsh for shell-related tasks
set foldmethod=marker             " Group folds with '{{{,}}}'
set grepprg=LC_ALL=C\ grep\ -rns  " Faster ASCII-based grep
set tabstop=2                     " width of tab
set shiftwidth=2                  " Digestable defaults for config files
set softtabstop=2                 " Set the number of columns for a tab
set expandtab                     " Prefer spaces over tabs
set hidden                        " Prefer hiding over unloading buffers
set wildcharm=<C-z>               " Macro-compatible command-line wildchar
set path=.,**                     " Search relative to current file + directory
set noswapfile                    " No swapfiles period.
set tags=./tags;,tags;            " ID Tags relative to current file + directory
set showcmd                       " show leader key pressed
let NERDTreeShowHidden=1          " let NERDtree show hidden files

" powerline tips and tricks
set laststatus=2                  " Always display the statusline in all windows
set showtabline=2                 " Always display the tabline, even if there is only one tab
set noshowmode                    " Hide the default mode text

" }}}

" Mappings {{{

" Change leader key
let mapleader = " "
 
" Self-explanatory convenience mappings
imap jj <Esc>
vmap jj <Esc>
nnoremap ' `
vnoremap ; :
vnoremap : ;
nnoremap ; :
nnoremap : ;

" move visual selection up or down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" tabularize
if exists(":Tabularize")
      nmap <Leader>a= :Tabularize /=<CR>
      vmap <Leader>a= :Tabularize /=<CR>
      nmap <Leader>a: :Tabularize /:\zs<CR>
      vmap <Leader>a: :Tabularize /:\zs<CR>
    endif

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" nerdtree
nnoremap <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" windows navigation
nnoremap <c-h> <c-w>k
nnoremap <c-j> <c-w>j 
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-\> <c-w>w

" resize windows
nnoremap <c-Left> :vertical resize -5<CR>
nnoremap <c-Down> :resize +5<CR>
nnoremap <c-Up> :resize -5<CR>
nnoremap <c-Right> :vertical resize +5<CR>

" format code automatically
nnoremap <leader>F :FormatCode<CR>
" Visually select pasted or yanked text
nnoremap gV `[v`]
" Toggle Paste mode
nnoremap <leader>p :set paste!<CR>
" Fast switching to the alternate file
nnoremap <BS> :buffer#<CR>
" Faster buffer navigation
nnoremap ,b :buffer *
" Black hole deletes
nnoremap <leader>d "_d
" Command-line like forward-search
cnoremap <C-k> <Up>
" Command-line like reverse-search
cnoremap <C-j> <Down>
" Often utilize vertical splits
cnoreabbrev v vert
" Fast global commands
nnoremap ,g :g//#<Left><Left>
" Faster project-based editing
nnoremap ,e :e **/*<C-z><S-Tab>

" Bindings for more efficient path-based file navigation
nnoremap ,f :find *
nnoremap ,v :vert sfind *
nnoremap ,F :find <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap ,V :vert sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>

" More manageable brace expansions
inoremap (; (<CR>);<C-c>O 
inoremap (, (<CR>),<C-c>O
inoremap {; {<CR>};<C-c>O
inoremap {, {<CR>},<C-c>O
inoremap [; [<CR>];<C-c>O 
inoremap [, [<CR>],<C-c>O 

" Useful for accessing commonly-used files
nnoremap <leader>v :e ~/.vimrc<CR>
nnoremap <leader>f :e <C-R>='~/.vim/ftplugin/'.&filetype.'.vim'<CR><CR>
nnoremap <leader>z :e ~/.zshrc<CR>
nnoremap <leader>C :e ~/.examples<CR>
nnoremap <leader>t :e ~/TODO<CR>

" Access file name data
cnoremap \fp <C-R>=expand("%:p:h")<CR>
tnoremap \fp <C-R>=expand("%:p:h")<CR>
inoremap \fp <C-R>=expand("%:p:h")<CR>
cnoremap \fn <C-R>=expand("%:t:r")<CR>
tnoremap \fn <C-R>=expand("%:t:r")<CR>
inoremap \fn <C-R>=expand("%:t:r")<CR>

" Symbol-based navigation
nnoremap ,t :tjump /
nnoremap ,d :dlist /
nnoremap ,i :ilist /

" External Grep
command! -nargs=+ -complete=file_in_path -bar Grep sil! grep! <args> | redraw!

" Custom function aliases
nnoremap <silent> ,G :Grep

" save as sudo when editing as user
cmap w!! w !sudo tee > /dev/null %

" }}}

" {{{ Autocommands
" Automatically source .vimrc on save
augroup Vimrc
  autocmd! bufwritepost .vimrc source %
augroup END

" Create file-marks for commonly edited file types
augroup FileMarks
  autocmd!
  autocmd BufLeave *.html normal! mH
  autocmd BufLeave *.json normal! mJ
  autocmd BufLeave *.ts   normal! mT
  autocmd BufLeave *.vim  normal! mV
  autocmd Bufleave *.yml  normal! mY
augroup END

" }}}
 
" Vundle Plugin Manager {{{
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" gruvbox
Plugin 'morhetz/gruvbox'

" NERD tree
Plugin 'scrooloose/nerdtree'

" NERD tree git plugin
Plugin 'Xuyuanp/nerdtree-git-plugin'

" Fugitive
Plugin 'tpope/vim-fugitive'

" Surround
Plugin 'tpope/vim-surround'

" Polyglot
Plugin 'sheerun/vim-polyglot'

" Pandoc syntax
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'

" Gitgutter
Plugin 'airblade/vim-gitgutter'

" textobj
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-entire'
Plugin 'kana/vim-textobj-indent'
Plugin 'kana/vim-textobj-line'

" System copy
Plugin 'christoomey/vim-system-copy'

" Repeat
Plugin 'tpope/vim-repeat'

" Commentary
Plugin 'tpope/vim-commentary'

" Ctrl P
Plugin 'ctrlpvim/ctrlp.vim'

" Lively Previewing LaTeX PDF Output
Plugin 'xuhdev/vim-latex-live-preview'

" Indent-guides
Plugin 'yggdroot/indentline'

" YouCompleteMe
Plugin 'valloric/youcompleteme'

" Tabular - align text
Plugin 'godlygeek/tabular'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" }}}


