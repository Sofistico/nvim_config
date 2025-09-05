-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
local use_dap_ui = false

return {
  'mfussenegger/nvim-dap',
  lazy = true,
  dependencies = {
    -- Creates a beautiful debugger UI
    { 'rcarriga/nvim-dap-ui', cond = use_dap_ui },
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {},
      cond = use_dap_ui,
    },
    {
      'igorlfs/nvim-dap-view',
      ---@module 'dap-view'
      ---@type dapview.Config
      opts = {
        windows = {
          terminal = {
            -- Use the actual names for the adapters you want to hide
            hide = { 'go', 'coreclr', 'netcoredbg', 'cs' }, -- `go` is known to not use the terminal.
          },
        },
      },
      cond = not use_dap_ui,
    },

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'stevearc/overseer.nvim',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<leader>dr',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F11>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F10>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F8>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<F9>',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>db',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        if use_dap_ui then
          require('dapui').toggle()
        else
          require('dap-view').toggle()
        end
      end,
      desc = 'Debug: See last session result.',
    },
    {
      '<leader>dp',
      function()
        require('dap').pause()
      end,
      desc = 'Pause',
    },
    {
      '<leader>dt',
      function()
        require('dap').terminate()
      end,
      desc = 'Terminate',
    },
    {
      '<leader>de',
      function()
        if use_dap_ui then
          local ui = require 'dapui'
          ui.eval()
        else
          require('dap-view').add_expr()
        end
      end,
      desc = 'Eval',
      mode = { 'n', 'v' },
    },
    {
      '<leader>dE',
      function()
        if use_dap_ui then
          local ui = require 'dapui'
          ui.eval()
          ui.eval()
        else
          vim.notify 'Keymap not configured!'
        end
      end,
      desc = 'Eval and jump to window',
      mode = { 'n', 'v' },
    },
    {
      '<leader>du',
      function()
        if use_dap_ui then
          require('dapui').toggle()
        else
          require('dap-view').toggle()
        end
      end,
      desc = 'Dap UI',
    },
    {
      '<leader>dc',
      function()
        require('dap').clear_breakpoints()
      end,
      desc = 'Clear Breakpoints',
    },
    {
      '<leader>dl',
      function()
        require('dap').list_breakpoints()
      end,
      desc = 'List Breakpoints',
    },
    {
      '<leader>dk',
      function()
        require('dap').up()
      end,
      desc = 'Up Stacktrace',
    },
    {
      '<leader>dj',
      function()
        require('dap').down()
      end,
      desc = 'Down Stacktrace',
    },
    {
      '<leader>dg',
      function()
        require('dap').goto_()
      end,
      desc = 'Goto Line in Debug (skip)',
    },
    {
      '<leader>dC',
      function()
        require('dap').run_to_cursor()()
      end,
      desc = 'Continue to cursor in Debug (execute)',
    },
    {
      '<leader>dR',
      function()
        require('dap').repl.toggle()
      end,
      desc = 'Toggle repl',
    },
  },
  config = function()
    local dap = require 'dap'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = false,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
      },
    }

    if use_dap_ui then
      local dapui = require 'dapui'
      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      ---@diagnostic disable-next-line: missing-fields
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        ---@diagnostic disable-next-line: missing-fields
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    else
      local dv = require 'dap-view'
      dap.listeners.before.attach['dap-view-config'] = function()
        dv.open()
      end
      dap.listeners.before.launch['dap-view-config'] = function()
        dv.open()
      end
      dap.listeners.before.event_terminated['dap-view-config'] = function()
        dv.close()
      end
      dap.listeners.before.event_exited['dap-view-config'] = function()
        dv.close()
      end
    end

    require('overseer').enable_dap()
    dap.listeners.after.event_initialized['dap_stop_backup'] = function(_, _)
      -- the write backup doesn't play nicely with c# watch command
      vim.o.writebackup = false
    end
    dap.listeners.after.event_terminated['dap_stop_backup'] = function(_, _)
      vim.o.writebackup = true
    end
    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    -- this is here because sometimes the netcoredbg dapper can't seem to find the breakpoint because of windows
    if vim.fn.has 'win32' then
      vim.opt.shellslash = false
    end
  end,
}
