return {
  'stevearc/overseer.nvim',
  cmd = { 'OverseerRun', 'OverseerToggle' },
  opts = { dap = false },
  -- version = '1.6.0',
  keys = {
    {
      '<leader>or',
      '<cmd>OverseerRun<cr>',
      desc = 'Task: Run',
    },
    {
      '<leader>os',
      '<cmd>OverseerShell<cr>',
      desc = 'Task: Shell',
    },
    {
      '<leader>O',
      '<cmd>OverseerToggle<cr>',
      desc = 'Overseer',
    },
    {
      'm<cr>',
      '<cmd>Make<cr>',
      desc = 'Make on background',
    },
    -- {
    --   'm<space>',
    --   '<cmd>Make ',
    --   desc = 'Make with command on background',
    -- },
  },
}
