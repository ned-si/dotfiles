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

nvim_lsp.gopls.setup {
  on_attach = on_attach
  }

nvim_lsp.ansiblels.setup {
  on_attach = on_attach
  }

nvim_lsp.terraformls.setup {
  on_attach = on_attach
  }

nvim_lsp.ltex.setup {
  on_attach = on_attach
  }

nvim_lsp.marksman.setup {
  on_attach = on_attach
  }

nvim_lsp.groovyls.setup {
  on_attach = on_attach
  }

nvim_lsp.jsonls.setup {
  on_attach = on_attach
  }

nvim_lsp.pylsp.setup {
  on_attach = on_attach
  }

nvim_lsp.dockerls.setup {
  on_attach = on_attach
  }

nvim_lsp.yamlls.setup {
  on_attach = on_attach
  }

require('lspconfig').yamlls.setup {
  settings = {
    yaml = {
      schemas = { kubernetes = "globPattern" },
    },
  }
}
EOF
