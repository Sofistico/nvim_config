return {
  {
    'folke/snacks.nvim',
    event = "VimEnter",
    lazy = false,
    priority = 1000,
    opts = {
      bufdelete = { enabled = true },
      words = { enabled = true },
      rename = { enabled = true },
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
