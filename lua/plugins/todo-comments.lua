-- Highlight todo, notes, etc in comments
return {
  {
    'folke/todo-comments.nvim',
    event = 'BufAdd',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
    keys = { { '<leader>st', '<cmd>TodoTelescope<cr>', desc = '[S]earch [T]odo' }, silent = true },
  },
}
-- vim: ts=2 sts=2 sw=2 et
