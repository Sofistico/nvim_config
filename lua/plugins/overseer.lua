return {
  'stevearc/overseer.nvim',
  cmd = { 'OverseerRun', 'OverseerToggle' },
  opts = { dap = false },
  keys = {
    {
      '<leader>o',
      '<cmd>OverseerShell<cr>',
      desc = 'Overseer Task bg',
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
  },
}
