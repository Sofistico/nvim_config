return {
  {
    'sindrets/diffview.nvim',
    opts = {},
    cmd = { 'DiffviewFileHistory', 'DiffviewFileHistory %', 'DiffviewOpen' },
    keys = {
      { '<leader>go', '<cmd>DiffviewOpen<cr>', desc = 'Open DiffView' },
      { '<leader>gf', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview this File' },
      { '<leader>gB', '<cmd>DiffviewFileHistory<cr>', desc = 'Diffview this Branch' },
      { '<leader>gO', '<cmd>DiffviewClose<cr>', desc = 'Close diff view' },
    },
  },
}
