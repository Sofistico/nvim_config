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
      image = { enabled = true, force = true },
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
      dashboard = {
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },
          { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
          -- { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
          {
            pane = 2,
            icon = ' ',
            title = 'Git Status',
            section = 'terminal',
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = 'git status --short --branch --renames',
            height = 20,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = 'startup' },
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
