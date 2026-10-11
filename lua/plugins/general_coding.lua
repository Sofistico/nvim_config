return -- snippets
{
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'BufAdd',
    lazy = true,
  },
  -- library used by other plugins
  { 'nvim-lua/plenary.nvim', lazy = true },
  {
    'shortcuts/no-neck-pain.nvim',
    version = '*',
    keys = { { '<leader>z', '<cmd>NoNeckPain<cr>', desc = 'Zoom screen' } },
    lazy = true,
    opts = { width = 150 },
  },
}
