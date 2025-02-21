vim.keymap.set('n', '<leader>dd', function()
  vim.cmd 'packadd termdebug'
  vim.cmd('Termdebug')
end, { desc = 'Debug with termdebug gdb' })
