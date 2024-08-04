require('nvim-treesitter.install').compilers = { 'clang' }
require('hardtime').setup()
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.cs' },
  command = 'comp dotnet',
})
