return {
  'mason-org/mason.nvim',
  lazy = true,
  cmd = { 'Mason', 'MasonUpdate' },
  opts = {
    registries = {
      'github:mason-org/mason-registry',
      'github:crashdummyy/mason-registry',
    },
  },
  keys = {
    { mode = 'n', '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' },
  },
}
