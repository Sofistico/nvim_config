vim.cmd 'comp! dotnet'
vim.cmd 'setlocal et sw=4'
vim.bo.mp = 'dotnet build --nologo /clp:NoSummary'

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
