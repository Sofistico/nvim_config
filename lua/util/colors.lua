local M = {}

function M.apply_custom_colors()
  -- csharp exclusive
  vim.cmd [[hi @lsp.type.enum.cs guifg=LightBlue]]
  vim.cmd [[hi @lsp.type.property.cs guifg=LightGreen]]
  vim.cmd [[hi @property.c_sharp guifg=LightGreen]]
end

return M
