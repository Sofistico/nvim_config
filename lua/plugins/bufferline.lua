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
      { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
      { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
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
        function ()
          vim.cmd.vsplit()
          require('bufferline').pick()
        end,
        desc = 'Pick Buffer and Vertical Split'
      },
      { '<leader>bI', '<Cmd>BufferLinePickClose<CR>', desc = 'Close Pick Buffer' },
      { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
      { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
      { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
      -- { '<leader>bs', '<Cmd>BufferLineSortByDirectory<CR>', desc = 'Sort buffer by directory' },
      -- { '<leader>bS', '<Cmd>BufferLineSortByExtension<CR>', desc = 'Sort buffer by relative directory' },
      -- { '<leader>bR', '<Cmd>BufferLineSortByRelativeDirectory<CR>', desc = 'Sort buffer by relative directory' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
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
