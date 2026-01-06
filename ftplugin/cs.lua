vim.cmd 'comp! dotnet'
vim.cmd 'setlocal et sw=4'

vim.bo.mp = 'dotnet build -v q --nologo /clp:NoSummary'

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

vim.keymap.set('n', '<leader>cw', function()
  dotnet.watch()
end, { desc = 'Run watch dotnet', silent = true, buffer = true })
