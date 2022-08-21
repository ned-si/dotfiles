require('telescope').setup{
  pickers = {
    live_grep = {
      additional_args = function(opts)
        return {"--hidden"}
      end
    },
  },
}
-- require('telescope').load_extension('dap')
