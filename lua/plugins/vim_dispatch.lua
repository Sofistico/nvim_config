return {
  {
    'radenling/vim-dispatch-neovim',
    lazy = true,
    cmd = { 'Dispatch', 'Make', 'Copen' },
    dependencies = { 'tpope/vim-dispatch' },
    keys = { '`<cr>', '` ', '\'<cr>', 'm<cr>', 'm!', '`!' },
  },
}
