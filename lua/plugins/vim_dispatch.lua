return {
  {
    'radenling/vim-dispatch-neovim',
    lazy = true,
    cmd = { 'Dispatch', 'Make', 'Copen' },
    dependencies = { 'tpope/vim-dispatch' },
    keys = {
      '`<cr>',
      '`<space>',
      "'<cr>",
      { 'm<cr>', '<cmd>Make<cr>', desc = 'Make' },
      { 'm!', '<cmd>Make!', desc = 'Make on background' },
      { 'm<space>', '<cmd>Make ', desc = 'Make with command' },
      '`!',
    },
  },
}
