return {
  {
    'nvim-neotest/neotest',
    opts = {
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          require('trouble').open { mode = 'quickfix', focus = false }
        end,
      },
    },
    lazy = true,
    keys = {
      { '<leader>T', '', desc = '+test' },
      {
        '<leader>Tt',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = 'Run File',
      },
      {
        '<leader>TT',
        function()
          require('neotest').run.run(vim.uv.cwd())
        end,
        desc = 'Run All Test Files',
      },
      {
        '<leader>Tr',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run Nearest',
      },
      {
        '<leader>Tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = 'Run Last',
      },
      {
        '<leader>Ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = 'Toggle Summary',
      },
      {
        '<leader>To',
        function()
          require('neotest').output.open { enter = true, auto_close = true }
        end,
        desc = 'Show Output',
      },
      {
        '<leader>TO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = 'Toggle Output Panel',
      },
      {
        '<leader>TS',
        function()
          require('neotest').run.stop()
        end,
        desc = 'Stop',
      },
      {
        '<leader>Tw',
        function()
          require('neotest').watch.toggle(vim.fn.expand '%')
        end,
        desc = 'Toggle Watch',
      },
    },
  },
}
