return -- snippets
{
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'BufAdd',
    lazy = true,
  },
  {
    'folke/todo-comments.nvim',
    event = 'BufAdd',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
    keys = { { '<leader>st', '<cmd>TodoTelescope<cr>', desc = '[S]earch [T]odo' }, silent = true },
  },
  -- library used by other plugins
  { 'nvim-lua/plenary.nvim', lazy = true },
}
