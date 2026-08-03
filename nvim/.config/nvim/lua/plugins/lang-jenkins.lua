-- Jenkinsfiles are Groovy, and LazyVim has no groovy extra, so this is the whole
-- setup. Filetype detection lives in config/autocmds.lua, because Jenkinsfiles
-- are almost never named *.groovy.
--
-- No language server here on purpose. groovyls wants a full Groovy/Gradle
-- classpath to say anything useful, which a Jenkinsfile does not have: the
-- pipeline DSL is injected by Jenkins at runtime, so a generic Groovy server
-- reports every `pipeline`, `stage` and `sh` as undefined. npm-groovy-lint knows
-- the DSL and gives real feedback instead.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "groovy" })
      end
    end,
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.groovy = { "npm-groovy-lint" }

      opts.linters = opts.linters or {}
      opts.linters["npm-groovy-lint"] = {
        cmd = "npm-groovy-lint",
        stdin = false,
        append_fname = true,
        args = {
          "--output",
          "json",
          "--failon",
          "none",
          -- Without this it applies the generic Groovy ruleset and complains
          -- about the pipeline DSL's own conventions.
          "--config",
          "recommended-jenkinsfile",
        },
        stream = "stdout",
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local diagnostics = {}
          if output == nil or output == "" then
            return diagnostics
          end
          local ok, decoded = pcall(vim.json.decode, output)
          if not ok or type(decoded) ~= "table" or not decoded.files then
            return diagnostics
          end

          local severity_map = {
            error = vim.diagnostic.severity.ERROR,
            warning = vim.diagnostic.severity.WARN,
            info = vim.diagnostic.severity.INFO,
          }

          for _, file in pairs(decoded.files) do
            for _, issue in ipairs(file.errors or {}) do
              table.insert(diagnostics, {
                bufnr = bufnr,
                -- npm-groovy-lint is 1-indexed; nvim diagnostics are 0-indexed.
                lnum = math.max((issue.line or 1) - 1, 0),
                col = 0,
                severity = severity_map[issue.severity]
                  or vim.diagnostic.severity.WARN,
                source = "npm-groovy-lint",
                message = issue.msg or "groovy lint",
              })
            end
          end
          return diagnostics
        end,
      }

      return opts
    end,
  },
}
