if !exists('g:loaded_lspsaga') | finish | endif

lua << EOF
local saga = require 'lspsaga'
saga.init_lsp_saga()
EOF

nnoremap <silent> <C-n> <cmd>Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> <C-p> <cmd>Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> K <cmd>Lspsaga hover_doc<CR>
inoremap <silent> gs <cmd>Lspsaga signature_help<CR>
nnoremap <silent> gh <cmd>Lspsaga lsp_finder<CR>
nnoremap <silent> ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent> ca <C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
nnoremap <silent> gR <cmd>Lspsaga rename<CR>
