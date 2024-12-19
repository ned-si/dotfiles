--l Fancier statusline

local function getWords()
  if
    vim.bo.filetype == "md"
    or vim.bo.filetype == "txt"
    or vim.bo.filetype == "markdown"
  then
    if vim.fn.wordcount().visual_words == 1 then
      return tostring(vim.fn.wordcount().visual_words) .. " word"
    elseif not (vim.fn.wordcount().visual_words == nil) then
      return tostring(vim.fn.wordcount().visual_words) .. " words"
    else
      return tostring(vim.fn.wordcount().words) .. " words"
    end
  else
    return ""
  end
end
--
-- local function get_schema()
--   local schema = require("yaml-companion").get_buf_schema(0)
--   if schema.result[1].name == "none" then
--     return ""
--   end
--   return schema.result[1].name
-- end

return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  opts = function()
    return {
      options = {
        icons_enabled = true,
        theme = "catppuccin",
        component_separators = { "|" },
        section_separators = { "" },
      },
      sections = {
        lualine_a = { getWords },
        -- lualine_x = { "fileformat", "filetype", get_schema },
      },
    }
  end,
}
