return {
  'nvzone/typr',
  dependencies = 'nvzone/volt',
  opts = {},
  cmd = { 'Typr', 'TyprStats' },
  keys = {
    {
      '<leader>Nt',
      '<cmd>Typr<cr>',
      desc = 'Typr'
    },
    {
      '<leader>NT',
      '<cmd>TyprStats<cr>',
      desc = 'Typr Stats'
    },
  },
}
