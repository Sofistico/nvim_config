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
    -- Toggle floating terminal on <F7> [term]
    -- https://github.com/akinsho/toggleterm.nvim
    -- neovim bug → https://github.com/neovim/neovim/issues/21106
    -- workarounds → https://github.com/akinsho/toggleterm.nvim/wiki/Mouse-support
    -- {
    --   'akinsho/toggleterm.nvim',
    --   cmd = { 'ToggleTerm', 'TermExec' },
    --   opts = {
    --     highlights = {
    --       Normal = { link = 'Normal' },
    --       NormalNC = { link = 'NormalNC' },
    --       NormalFloat = { link = 'Normal' },
    --       FloatBorder = { link = 'FloatBorder' },
    --       StatusLine = { link = 'StatusLine' },
    --       StatusLineNC = { link = 'StatusLineNC' },
    --       WinBar = { link = 'WinBar' },
    --       WinBarNC = { link = 'WinBarNC' },
    --     },
    --     size = 10,
    --     open_mapping = [[<F7>]],
    --     shading_factor = 2,
    --     direction = 'float',
    --     float_opts = {
    --       border = 'rounded',
    --       highlights = { border = 'Normal', background = 'Normal' },
    --     },
    --   },
    -- },
  },
}
