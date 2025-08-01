return {
  -- Better `vim.notify()`
  {
    'rcarriga/nvim-notify',
    lazy = false,
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
      timeout = 1500,
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
  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  -- {
  --   'folke/noice.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     lsp = {
  --       override = {
  --         ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
  --         ['vim.lsp.util.stylize_markdown'] = true,
  --         ['cmp.entry.get_documentation'] = true,
  --       },
  --     },
  --     routes = {
  --       {
  --         filter = {
  --           event = 'msg_show',
  --           any = {
  --             { find = '%d+L, %d+B' },
  --             { find = '; after #%d+' },
  --             { find = '; before #%d+' },
  --           },
  --         },
  --         view = 'mini',
  --       },
  --     },
  --     presets = {
  --       bottom_search = true,
  --       command_palette = true,
  --       long_message_to_split = true,
  --     },
  --   },
  --   -- stylua: ignore
  --   keys = {
  --     { "<leader>sn", "", desc = "+noice"},
  --     { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
  --     { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
  --     { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
  --     { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
  --     { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
  --     { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
  --     { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
  --     { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
  --   },
  --   config = function(_, opts)
  --     -- HACK: noice shows messages from before it was enabled,
  --     -- but this is not ideal when Lazy is installing plugins,
  --     -- so clear the messages in this case.
  --     if vim.o.filetype == 'lazy' then
  --       vim.cmd [[messages clear]]
  --     end
  --     require('noice').setup(opts)
  --   end,
  -- },
}
