return {
  'mbbill/undotree',
  -- event = 'InsertLeave',
  keys = {
    {
      '<leader>tu',
      vim.cmd.UndotreeToggle,
      desc = 'Undotree Toggle',
    },
  },
}
