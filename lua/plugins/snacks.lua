return {
  {
    'folke/snacks.nvim',
    event = 'VimEnter',
    lazy = false,
    priority = 1000,
    opts = {
      bufdelete = { enabled = true },
      rename = { enabled = true },
      toggle = { enabled = true },
      input = { enabled = true },
      image = { enabled = true },
      styles = {
        input = {
          relative = 'cursor',
          col = 0,
          row = -3,
          keys = {
            i_ctrl_k = { '<c-k>', { 'cmp_accept', 'confirm' }, mode = 'i', expr = true },
          },
        },
      },
    },
    config = function(_, opts)
      local snacks = require 'snacks'
      snacks.setup(opts)
      snacks.toggle.option('wrap', { name = 'Toogle word wrap' }):map '<leader>tw'
      snacks.toggle.diagnostics():map '<leader>tt'
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
        '<leader>ti',
        function()
          require('snacks').image.hover()
        end,
        desc = 'Toggle image hover',
      },
    },
  },
}
