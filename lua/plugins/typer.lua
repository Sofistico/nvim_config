return {
  'nvzone/typr',
  dependencies = 'nvzone/volt',
  opts = {},
  cmd = { 'Typr', 'TyprStats' },
  keys = {
    {
      '<leader>nt',
      '<cmd>Typr<cr>',
      desc = 'Typr'
    },
    {
      '<leader>nT',
      '<cmd>TyprStats<cr>',
      desc = 'Typr Stats'
    },
  },
}
