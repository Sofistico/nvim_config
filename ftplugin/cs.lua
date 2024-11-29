vim.cmd 'comp dotnet'

local cs = require 'csharp'

vim.keymap.set('n', '<C-F5>', cs.run_project, { desc = 'Run csharp', buffer = true })
vim.keymap.set('n', '<leader>dD', cs.debug_project, { desc = 'Debug csharp', buffer = true })
vim.keymap.set('n', '<F5>', cs.debug_project, { desc = 'Debug csharp', buffer = true })

vim.keymap.set('n', '<leader>cn', '<cmd>DotnetUI new_item<cr>', { desc = 'New Dotnet item', silent = true, buffer = true })
vim.keymap.set('n', '<leader>cN', '<cmd>DotnetUI file bootstrap<cr>', { desc = 'Bootstrap new file', silent = true, buffer = true })
vim.keymap.set('n', '<leader>cp', '<cmd>DotnetUI project package add<cr>', { desc = 'Add new nuget package', silent = true, buffer = true })
vim.keymap.set('n', '<leader>cP', '<cmd>DotnetUI project reference add<cr>', { desc = 'Add new project reference', silent = true, buffer = true })
