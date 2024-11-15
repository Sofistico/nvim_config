return {
  {
    'folke/snacks.nvim',
    lazy = true,
    opts = {
      bufdelete = { enabled = true },
      words = { enabled = true },
      rename = { enabled = true },
      toggle = { enabled = true },
      lazygit = { enabled = false },
      terminal = { enabled = false },
      notifier = { enabled = false },
    },
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
