return {
  'mason-org/mason.nvim',
  lazy = true,
  cmd = { 'Mason', 'MasonUpdate' },
  opts = {
    registries = {
      'github:mason-org/mason-registry',
      'github:Crashdummyy/mason-registry',
    },
  },
}
