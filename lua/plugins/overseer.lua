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
  },
}
