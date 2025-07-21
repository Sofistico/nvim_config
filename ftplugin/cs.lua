vim.cmd 'comp! dotnet'
vim.cmd 'setlocal et sw=4'
if vim.g.roslyn_nvim_selected_solution then
  local sln = vim.fn.fnamemodify(vim.g.roslyn_nvim_selected_solution, ':.')
  vim.bo.mp = 'dotnet build ' .. sln .. ' --nologo /clp:NoSummary'
else
  vim.bo.mp = 'dotnet build --nologo /clp:NoSummary'
end

local dotnet = require 'easy-dotnet'

vim.keymap.set('n', '<leader>cn', function()
  dotnet.new()
end, { desc = 'New Dotnet item', silent = true, buffer = true })

vim.keymap.set('n', '<leader>cs', function()
  dotnet.secrets()
end, { desc = 'Dotnet secrets', silent = true, buffer = true })

-- vim.keymap.set('n', '<leader>cN', '<cmd>DotnetUI file bootstrap<cr>', { desc = 'Bootstrap new file', silent = true, buffer = true })
vim.keymap.set('n', '<leader>cp', function()
  dotnet.add_package()
end, { desc = 'Add new nuget package', silent = true, buffer = true })

vim.keymap.set('n', '<leader>cP', function()
  dotnet.project_view()
end, { desc = 'Project view', silent = true, buffer = true })

vim.keymap.set('n', '<leader>cS', function()
  dotnet.solution_select()
end, { desc = 'Select solution', silent = true, buffer = true })

vim.keymap.set('n', '<leader>cr', function()
  dotnet.run()
end, { desc = 'Run dotnet', silent = true, buffer = true })

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
