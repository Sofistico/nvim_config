local use_nvim_notify = true

return {
  {
    'j-hui/fidget.nvim',
    lazy = use_nvim_notify,
    opts = { notification = { override_vim_notify = not use_nvim_notify } },
    keys = (use_nvim_notify and {}) or {
      {
        '<leader>nh',
        function()
          require('fidget.notification').show_history()
        end,
        desc = 'Show notification history',
      },
    },
  },
  -- Better `vim.notify()`
  {
    'rcarriga/nvim-notify',
    lazy = false,
    cond = use_nvim_notify,
    event = 'VeryLazy',
    keys = {
      {
        '<leader>nd',
        function()
          require('notify').dismiss { silent = true, pending = true }
        end,
        desc = 'Dismiss All Notifications',
      },
      {
        '<leader>k',
        function()
          require('notify').dismiss { silent = true, pending = true }
        end,
        desc = 'Kill All Notifications',
      },
      { '<leader>nh', '<cmd>Telescope notify<cr>', desc = 'Show Notification History' },
    },
    opts = {
      stages = 'static',
      timeout = 1000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    config = function()
      vim.notify = require 'notify'
    end,
  },
}
