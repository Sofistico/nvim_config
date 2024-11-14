return {
  {
    'folke/snacks.nvim',
    lazy = true,
    opts = {
      styles = { enable = false },
      bigfile = { enabled = false },
      notifier = { enabled = false },
      quickfile = { enabled = false },
      statuscolumn = { enabled = false },
      git = { enabled = false },
      gitbrowse = { enabled = false },
      notify = { enabled = false },
      terminal = { enabled = false },
      win = { enabled = false },
      debug = { enabled = false },
      lazygit = { enabled = false },
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
