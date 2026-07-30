-- Python is the day job. LazyVim's lang.python extra already brings basedpyright
-- and ruff; this only adjusts what work tooling expects.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                -- basedpyright defaults to "all", which turns a normal AWS
                -- Lambda repo into a wall of warnings about untyped third-party
                -- calls. "standard" is the useful signal without the noise.
                typeCheckingMode = "standard",
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                },
              },
            },
          },
        },
        ruff = {
          -- Formatting and import sorting come from ruff, so pyright must not
          -- also offer them or you get two competing organise-imports actions.
          init_options = {
            settings = { organizeImports = true },
          },
        },
      },
    },
  },

  -- Resolve the interpreter from the project's own virtualenv. work-cli pins
  -- UV_TOOL_DIR to its own uv environment, which is not the venv a given repo
  -- wants, so leaving this to autodetection picks the wrong Python.
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    ft = "python",
    opts = {
      search = {
        -- uv and standard venv layouts, plus pyenv's shared directory.
        cwd = { command = "fd '/bin/python$' . --full-path --color never -E /proc -HI -a -L" },
      },
      options = { notify_user_on_venv_activation = true },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", ft = "python", desc = "Select venv" },
    },
  },
}
