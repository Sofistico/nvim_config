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
      { '<leader>re', ':Refactor extract ', desc = 'Extract' },
      { '<leader>rf', ':Refactor extract_to_file ', desc = 'Extract to File' },
      { '<leader>rv', ':Refactor extract_var ', desc = 'Extract Variable' },
      { '<leader>ri', ':Refactor inline_var', desc = 'Inline Variable', mode = { 'n', 'x' } },
      { '<leader>rI', ':Refactor inline_func', desc = 'Inline Function' },
      { '<leader>rb', ':Refactor extract_block', desc = 'Extract Block' },
      { '<leader>rbf', ':Refactor extract_block_to_file', desc = 'Extract Block to File' },
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
  {
    'rmagatti/goto-preview',
    lazy = true,
    config = true,
    keys = {
      {
        'gpd',
        function()
          require('goto-preview').goto_preview_definition()
        end,
        desc = 'Preview Definition',
        silent = true,
      },
      {
        'gpt',
        function()
          require('goto-preview').goto_preview_type_definition()
        end,
        desc = 'Preview Type Definition',
        silent = true,
      },
      {
        'gpi',
        function()
          require('goto-preview').goto_preview_type_definition()
        end,
        desc = 'Preview Implementation',
        silent = true,
      },
      {
        'gpr',
        function()
          require('goto-preview').goto_preview_references()
        end,
        desc = 'Preview References',
        silent = true,
      },
      {
        'gpc',
        function()
          require('goto-preview').close_all_win()
        end,
        desc = 'Close Previews',
        silent = true,
      },
    },
  },
}
