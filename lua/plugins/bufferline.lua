return {
  -- This is what powers LazyVim's fancy-looking
  -- tabs, which include filetype icons and close buttons.
  {
    'akinsho/bufferline.nvim',
    event = 'BufAdd',
    dependencies = {
      'folke/snacks.nvim',
    },
    keys = {
      { '<leader>bi', '<Cmd>BufferLinePick<CR>', desc = 'Pick Buffer' },
      {
        '<leader>bs',
        function()
          vim.cmd.split()
          require('bufferline').pick()
        end,
        desc = 'Pick Buffer and Split',
      },
      {
        '<leader>bv',
        function()
          vim.cmd.vsplit()
          require('bufferline').pick()
        end,
        desc = 'Pick Buffer and Vertical Split',
      },
      { '<leader>bI', '<Cmd>BufferLinePickClose<CR>', desc = 'Close Pick Buffer' },
      { '<leader>bO', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
      {
        '<leader>bo',
        function()
          require('bufferline').sort_by(function(buffer_a, buffer_b)
            local modified_a = vim.fn.getftime(buffer_a.path)
            local modified_b = vim.fn.getftime(buffer_b.path)
            return modified_a > modified_b
          end)
        end,
        desc = 'Sort buffer by last used',
      },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
      { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
    },
    opts = {
      options = {
        close_command = function(n)
          require('snacks').bufdelete(n)
        end,
        right_mouse_command = function(n)
          require('snacks').bufdelete(n)
        end,
        diagnostics = false, --"nvim_lsp"
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require('local-icons').diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. ' ' or '') .. (diag.warning and icons.Warn .. diag.warning or '')
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    },
  },
}
