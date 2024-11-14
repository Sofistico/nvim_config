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
      words = { enabled = false },
    },
    keys = {
      {
        '<leader>bd',
        function()
          require('snacks').bufdelete()
        end,
        desc = 'Delete Buffer',
      },
    },
  },
}
