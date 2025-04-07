return {
  'stevearc/overseer.nvim',
  cmd = { 'OverseerRun', 'OverseerToggle' },
  opts = { dap = false },
  keys = {
    {
      '<leader>or',
      '<cmd>OverseerRun<cr>',
      desc = 'Task: Run',
    },
    {
      '<leader>ot',
      '<cmd>OverseerToggle<cr>',
      desc = 'Task: Open',
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
