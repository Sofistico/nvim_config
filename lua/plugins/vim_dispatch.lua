return {
  {
    'radenling/vim-dispatch-neovim',
    lazy = true,
    cmd = { 'Dispatch', 'Make', 'Copen' },
    dependencies = { 'tpope/vim-dispatch' },
    -- keys = { { '<leader>cM', '<cmd>Make<cr>', desc = 'Make file/folder/project' } },
  },
}
