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
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('refactoring').setup {}
      require('telescope').load_extension 'refactoring'
    end,
    keys = {
      { '<leader>re', '<cmd>Refactor extract<CR>', desc = 'Extract', mode = { 'n', 'x' } },
      { '<leader>rf', '<cmd>Refactor extract_to_file<CR>', desc = 'Extract to File', mode = { 'n', 'x' } },
      { '<leader>rv', '<cmd>Refactor extract_var<CR>', desc = 'Extract Variable' },
      { '<leader>ri', '<cmd>Refactor inline_var<CR>', desc = 'Inline Variable', mode = { 'n', 'x' } },
      { '<leader>rI', '<cmd>Refactor inline_func<CR>', desc = 'Inline Function', mode = { 'n', 'x' } },
      { '<leader>rb', '<cmd>Refactor extract_block<CR>', desc = 'Extract Block', mode = { 'n', 'x' } },
      { '<leader>rB', '<cmd>Refactor extract_block_to_file<CR>', desc = 'Extract Block to File', mode = { 'n', 'x' } },
      {
        '<leader>rr',
        function()
          require('telescope').extensions.refactoring.refactors()
        end,
        desc = 'Refactor Select',
        mode = { 'n', 'x' },
      },
    },
  },
}
