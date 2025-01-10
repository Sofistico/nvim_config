return {
  {
    'folke/snacks.nvim',
    event = 'VimEnter',
    lazy = false,
    priority = 1000,
    opts = {
      bufdelete = { enabled = true },
      words = { enabled = true },
      rename = { enabled = true },
      toggle = { enabled = true },
    },
    config = function(_, opts)
      local snacks = require 'snacks'
      snacks.setup(opts)
      snacks.toggle.option('wrap', { name = 'Toogle word wrap' }):map '<leader>tw'
      snacks.toggle.diagnostics():map '<leader>tD'
    end,
    keys = {
      {
        '<leader>bd',
        function()
          require('snacks').bufdelete()
        end,
        desc = 'Delete Buffer',
      },
      {
        ']]',
        function()
          require('snacks').words.jump(vim.v.count1)
        end,
        desc = 'Next Reference',
        mode = { 'n', 't' },
      },
      {
        '[[',
        function()
          require('snacks').words.jump(-vim.v.count1)
        end,
        desc = 'Prev Reference',
        mode = { 'n', 't' },
      },
    },
  },
}
