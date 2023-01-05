require("esqueleto").setup(
    {
      -- Directory where templates are stored
      directory = "~/.config/nvim/template/",

      -- Patterns to match when creating new file
      -- Can be either (i) file names or (ii) file types.
      -- Exact file name match have priority
      patterns = { "markdown" }
    }
)
