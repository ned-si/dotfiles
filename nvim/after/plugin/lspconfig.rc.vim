if !exists('g:lspconfig')
  finish
endif

lua << EOF
local nvim_lsp = require ('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings
  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'ff', '<Cmd>lua vim.lsp.buf.format { async = true }()<CR>', opts)

  if client.server_capabilities.document_formatting then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end
end

local servers = {'gopls', 'ansiblels', 'terraformls', 'ltex', 'marksman', 'groovyls', 'jsonls', 'pylsp', 'dockerls', 'yamlls'}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
  }
end

require('lspconfig').yamlls.setup {
  settings = {
    yaml = {
      schemas = { kubernetes = "globPattern" },
    },
  }
}
EOF

" if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
"       vim.diagnostic.disable(bufnr)
"       vim.defer_fn(function()
"         vim.diagnostic.reset(nil, bufnr)
"       end, 1000)
"     end
