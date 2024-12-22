local M = {}

function M.apply_custom_colors()
  -- csharp exclusive
  vim.cmd [[hi @lsp.type.enum.cs guifg=SlateBlue]]
  vim.cmd [[hi @lsp.type.property.cs guifg=DarkCyan]]
  vim.cmd [[hi @property.c_sharp guifg=DarkCyan]]
end

return M
