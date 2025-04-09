vim.cmd 'comp! dotnet'
vim.cmd 'setlocal et sw=4'
vim.bo.mp = 'dotnet build --nologo /clp:NoSummary'

vim.keymap.set('n', '<leader>cn', '<cmd>DotnetUI new_item<cr>', { desc = 'New Dotnet item', silent = true, buffer = true })
vim.keymap.set('n', '<leader>cN', '<cmd>DotnetUI file bootstrap<cr>', { desc = 'Bootstrap new file', silent = true, buffer = true })
vim.keymap.set('n', '<leader>cp', '<cmd>DotnetUI project package add<cr>', { desc = 'Add new nuget package', silent = true, buffer = true })
vim.keymap.set('n', '<leader>cP', '<cmd>DotnetUI project reference add<cr>', { desc = 'Add new project reference', silent = true, buffer = true })

vim.keymap.set('n', '<leader>te', function()
  vim.g.dotnet_errors_only = not vim.g.dotnet_errors_only
  vim.notify('Toggled dotnet errors: ' .. tostring(vim.g.dotnet_errors_only))
  vim.cmd 'comp! dotnet'
  if vim.g.dotnet_errors_only then
    vim.bo.mp = 'dotnet build --nologo -v q --property WarningLevel=0 /clp:ErrorsOnly'
  else
    vim.bo.mp = 'dotnet build --nologo /clp:NoSummary'
  end
end, { desc = 'Toggle dotnet errors only', buffer = true })
