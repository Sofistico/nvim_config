return {
  'mbbill/undotree',
  -- event = 'InsertLeave',
  keys = {
    {
      '<leader>u',
      vim.cmd.UndotreeToggle,
      desc = 'Undotree Toggle',
    },
  },
}
